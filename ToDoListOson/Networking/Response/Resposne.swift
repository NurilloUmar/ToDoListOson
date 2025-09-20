//
//  AppDelegate.swift
//  ToDoListOson
//
//  Created by hayot on 9/18/25.
//



struct ToDoResponse: Codable {
    var userId: Int
    var title: String
    var id: Int
    var completed: Bool
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.title = try container.decode(String.self, forKey: .title)
        self.id = try container.decode(Int.self, forKey: .id)
        self.completed = try container.decode(Bool.self, forKey: .completed)
    }
    
}

struct APIUserResponse: Codable {
    
    var data: [UserResponse]?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try? container.decode([UserResponse].self, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    
}

struct UserResponse: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company

    struct Address: Codable {
        let street: String
        let suite: String
        let city: String
        let zipcode: String
        let geo: Geo
        struct Geo: Codable {
            let lat: String
            let lng: String
        }
    }

    struct Company: Codable {
        let name: String
        let catchPhrase: String
        let bs: String
    }
    
}


struct ModelCoreDM {
    let id: Int64?
    let title: String?
    let completed: Bool?
    let userName: String?
    let email: String?
}
