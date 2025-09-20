//
//  ToDoServices.swift
//  ToDoListOson
//
//  Created by hayot on 9/19/25.
//

import Foundation

struct ToDoService: BaseService{
    
    typealias Convertible = ToDoRouter

    func getTodos(completion: @escaping Completion<[ToDoResponse]>){
        request( .getListResult, completion: completion)
    }
    
    func getUsersInfo(completion: @escaping Completion<[UserResponse]>){
        request( .getUserResult, completion: completion)
    }
    
}
