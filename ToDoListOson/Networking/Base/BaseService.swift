//
//  AppDelegate.swift
//  ToDoListOson
//
//  Created by hayot on 9/18/25.
//


import Alamofire

/// Barcha xizmatlar uchun asosiy protokol
protocol BaseService {
    associatedtype Convertible: URLRequestConvertible
    typealias Completion<T> = (Result<T, NetworkError>) -> Void
    
    /// Tarmoq so‘rovini bajaruvchi metod
    /// - Parameters:
    ///   - convertible: So‘rovni o‘zgartiruvchi protokol (`URLRequestConvertible`)
    ///   - completion: Javobni qaytaruvchi qism (`Result<T, NetworkError>`)
    func request<T: Codable>(_ convertible: Convertible, completion: @escaping Completion<T>)
}

extension BaseService {
    
    /// So‘rov yuborish va javobni qayta ishlash
    /// - Parameters:
    ///   - convertible: So‘rovni o‘zgartiruvchi protokol (`URLRequestConvertible`)
    ///   - completion: Javobni qaytaruvchi qism (`Result<T, NetworkError>`)
    func request<T: Codable>(_ convertible: Convertible, completion: @escaping Completion<T>) {
        // So‘rov yaratish
        let request = AF.request(convertible)
        
        // Javobni olish va qayta ishlash
        request.responseDecodable(queue: .global(qos: .background)) { response in
            // Javobni tahlil qilish va kuzatish
            AnalysisResponseMonitor<T>(response: response).monitor(completion: completion)
        }
    }
}
