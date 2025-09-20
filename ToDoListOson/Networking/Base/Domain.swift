
//
//  AppDelegate.swift
//  ToDoListOson
//
//  Created by hayot on 9/18/25.
//

enum Domain {
    case base
    
    var urlString: String {
        switch self {
        case .base:
            return "https://jsonplaceholder.typicode.com"
        }
    }
}



