//
//  Todo+CoreDataProperties.swift
//  Todo
//
//  Created by Dmitry Tsybulkin on 2023-07-31.
//
//

import Foundation
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {

}

extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var done: Bool
    @NSManaged public var id: UUID
    @NSManaged public var text: String
	
	convenience init(id: UUID, text: String, done: Bool) {
		self.init()
		self.id = id
		self.text = text
		self.done = done
	}

}

extension Todo : Identifiable {

}
