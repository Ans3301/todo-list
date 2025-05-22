//
//  ToDoItem+CoreDataProperties.swift
//  todo-list
//
//  Created by Мария Анисович on 22.05.2025.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var isDone: Bool
    @NSManaged public var creationDate: Date
    @NSManaged public var desc: String
    @NSManaged public var title: String
    @NSManaged public var id: UUID

}

extension ToDoItem : Identifiable {

}
