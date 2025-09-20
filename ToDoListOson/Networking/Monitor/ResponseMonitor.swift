import Alamofire
import Foundation
import SwiftyJSON

struct AnalysisResponseMonitor<T> where T: Codable {
    
    private let response: DataResponse<T, AFError>
    
    public init(response: DataResponse<T, AFError>) {
        self.response = response
    }
    
    /**
     Javobni tahlil qiladi va foydalanuvchi uchun kod va ma'lumotlarni qaytaradi
     
     - Parameters:
       - completion: Monitor tugagandan so‘ng chaqiriladi
     */
    internal func monitor(completion: @escaping (Result<T, NetworkError>) -> Void) {
        do {
            let statusCode = try inspectStatusCode()
            NetworkLogger.log(response)
            
            switch statusCode {
            case 200..<300:
                try handleSuccess(completion: completion)
            default:
                try handleFailure(statusCode: statusCode)
            }
        } catch {
            handleUnexpectedError(error, completion: completion)
        }
    }
    
    private func handleSuccess(completion: @escaping (Result<T, NetworkError>) -> Void) throws {
        switch response.result {
        case .success:
            let model = try NetworkDecoder<T>().decode(from: response.data)
            DispatchQueue.main.async {
                completion(.success(model))
            }
        case .failure(let error):
            handleDecodingError(error, completion: completion)
        }
    }
    
    private func handleFailure(statusCode: Int) throws {
        guard let responseData = response.data else {
            throw NetworkError.unexpected(description: "Ma'lumotlarni olishda xatolik")
        }
        let json = JSON(try JSONSerialization.jsonObject(with: responseData, options: []))
        throw NetworkError.unexpected(description: json["message"].stringValue)
    }
    
    private func handleUnexpectedError(_ error: Error, completion: @escaping (Result<T, NetworkError>) -> Void) {
        if let networkError = error as? NetworkError {
            DispatchQueue.main.async {
                completion(.failure(networkError))
            }
        } else {
            DispatchQueue.main.async {
                completion(.failure(.unexpected(description: "Noma'lum xatolik yuz berdi")))
            }
        }
    }
    
    private func handleDecodingError(_ error: AFError, completion: @escaping (Result<T, NetworkError>) -> Void) {
        NetworkLogger<T>.responseErrorMessage(response.data) { errorMsg, _ in
            DispatchQueue.main.async {
                print("Decoding xatolik: \(errorMsg)")
                completion(.failure(.unexpected(description: error.localizedDescription)))
            }
        }
    }
    
    // Status kodni tekshirish
    private func inspectStatusCode() throws -> Int {
        guard let statusCode = response.response?.statusCode else {
            throw NetworkError.unexpected(description: "Internet aloqasi uzildi")
        }
        return statusCode
    }
}
