//
//  ToDoRouter.swift
//  ToDoListOson
//
//  Created by hayot on 9/19/25.

import Foundation
import Alamofire

enum ToDoRouter: BaseURLRequestConvertible {
    
    case getListResult

    case getUserResult
    
    var path: String {
        switch self{
        case .getListResult:
            return "todos"
        case .getUserResult:
            return "users"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getListResult:
            return .get
        case .getUserResult:
            return .get
        }
    }
    
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case.getListResult:
            return nil
        case .getUserResult:
            return nil
        }
        
    }
    
    
    func asURLRequest() throws -> URLRequest {
        
        let url = makeURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.add(contentOf: .defaultHeaders)
        if let parameters = parameters {
            urlRequest = try JSONEncoding().encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
    
    
}
