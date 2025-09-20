

import Foundation

struct NetworkDecoder<T: Decodable> {
    enum DecodeError: Swift.Error {
        case dataNotFound(description: String)
        case unableToDecode(description: String)
        case unableToConvertData(descripion: String)
    }
    
    func decode(from dictionary: NSDictionary) throws -> T {
        let data = try convertToData(dictionary: dictionary)
        
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            throw DecodeError.unableToDecode(description: error.localizedDescription)
        }
    }
    
    func decode(from data: Data?) throws -> T {
        guard let data = data else {
            throw DecodeError.dataNotFound(description: "Data not found")
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func convertToData(dictionary: NSDictionary) throws -> Data {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return data
        } catch {
            throw DecodeError.unableToConvertData(descripion: error.localizedDescription)
        }
    }
}
