

import UIKit
import Alamofire
import SwiftyJSON

internal final class NetworkLogger<T> where T: Codable {
//    fileprivate static var logCounter = 0
    
    static func log(_ task: DataResponse<T, AFError>) {
        #if DEBUG
        guard let request = task.request, let response = task.response else {
            return
        }
        
        DispatchQueue.global(qos: .background).sync {
            print("» [\(response.statusCode)] \(request.httpMethod ?? "") \(request)\n")
            logHeaders(title: "Request", headers: request.allHTTPHeaderFields)
            logHeaders(title: "Response", headers: response.allHeaderFields)
            logData(task.data)
            logDivider()
        }
        #endif
    }
    
    private static func logData(_ data: Data?) {
        guard let data = data else { return }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            if let prettyPrintedString = String(data: prettyData, encoding: .utf8) {
                print(prettyPrintedString)
            }
        } catch {
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                print(string)
            }
        }
    }
    
    private static func logDivider(header: String? = nil) {
        print("\n« ------------- « ----------------- « \(header ?? "o") » ------------- » ----------------- »\n")
    }
    
    private static func logHeaders(title: String = "", headers: [AnyHashable : Any]?) {
        guard let headers = headers else { return }
        
        print("\(title) Headers: [")
        for (key, value) in headers {
            print("  \(key) : \(value)")
        }
        print("]\n")
    }
    
    public static func responseErrorMessage(_ data: Data?, completion: @escaping(String, Int) -> Void) {
        guard let responseData = data else { return }
        
        do {
            let json = JSON(try JSONSerialization.jsonObject(with: responseData, options: []))
            completion(json["result_msg"].stringValue, json["result_code"].intValue)
        } catch {
            if let string = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue) {
                completion(string as String, -1)
            }
        }
    }
}
