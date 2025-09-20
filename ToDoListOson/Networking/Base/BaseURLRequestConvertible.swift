//
//  AppDelegate.swift
//  ToDoListOson
//
//  Created by hayot on 9/18/25.
//


import Alamofire
import Foundation

/// URL so‘rovlarini yaratish uchun asosiy protokol
protocol BaseURLRequestConvertible: URLRequestConvertible {
    typealias Headers = [Header.Key: Header.Value]
    
    /// So‘rovning endpoint manzili
    var path: String { get }
    
    /// HTTP metodi (GET, POST, PUT, DELETE va boshqalar)
    var method: HTTPMethod { get }
    
    /// So‘rov uchun parametrlar (Query yoki Body)
    var parameters: Parameters? { get }
    
    /// So‘rov uchun kerakli sarlavhalar (Headers)
    var headers: Headers { get }
    
    /// Asosiy domen
    var baseDomain: Domain { get }
}

// MARK: - Default Implementations (OCP - Open/Closed Principle)
extension BaseURLRequestConvertible {
    var baseDomain: Domain { .base }
    var headers: Headers { .defaultHeaders }
    
    /// URL manzilini yaratish (Single Responsibility Principle - faqat URL yaratish vazifasi)
    func makeURL() -> URL {
        let sanitizedPath = sanitizePath(path)
        let fullPath = "\(baseDomain.urlString)/\(sanitizedPath)"
        return URL(string: fullPath)!
        
       // URL(string: fullPath.encodeUrl.replacingOccurrences(of: "%25", with: "%"))!
    }
    
    /// Pathni tekshirish va sozlash
    private func sanitizePath(_ path: String) -> String {
        return path.hasPrefix("/") ? String(path.dropFirst()) : path
    }
}

// MARK: - Headers Management (ISP - Interface Segregation Principle)
extension Dictionary where Key == Header.Key, Value == Header.Value {
    static var defaultHeaders: Self {
        return [
            .accept: .applicationJSON,
            .contentType: .applicationJSON,
            .authorization: .token,
            .language: .language
        ]
    }
}

