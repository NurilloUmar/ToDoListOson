//
//  ToDoListItem+CoreDataClass.swift
//  ToDoListOson
//
//  Created by hayot on 9/20/25.


import Foundation
import CoreData

@objc(ToDoListItem)
public class ToDoListItem: NSManagedObject {

    static let entityName = "ToDoListItem"

    @NSManaged public var id: Int64
    @NSManaged public var userName: String?
    @NSManaged public var completed: Bool
    @NSManaged public var email: String?
    @NSManaged public var title: String?

    var model: ModelCoreDM {
        get {
            return ModelCoreDM(
                id: id,
                title: title,
                completed: completed,
                userName: userName,
                email: email
            )
        }
        set {
            self.id = newValue.id ?? 0
            self.title = newValue.title
            self.completed = newValue.completed ?? false
            self.userName = newValue.userName
            self.email = newValue.email
        }
    }
}
