//
//  Persistence.swift
//  Todo
//
//  Created by Dmitry Tsybulkin on 2023-07-31.
//

import CoreData

struct PersistenceController {
	
	static let shared: PersistenceController = PersistenceController()

    let container: NSPersistentContainer
	
	init(inMemory: Bool = false) {
		self.container = NSPersistentContainer(name: "Todo")
		if inMemory {
			container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
		}
		container.viewContext.automaticallyMergesChangesFromParent = true
		container.loadPersistentStores { desc, error in
			if let error = error as NSError? {
				fatalError("pizdec... \(error), \(error.userInfo)")
			}
		}
	}
	
	static var preview: PersistenceController = {
		let result = PersistenceController(inMemory: true)
		let viewContext = result.container.viewContext
		buildTodo(ctx: viewContext, text: "Learn swift")
		buildTodo(ctx: viewContext, text: "Feed cat")
		buildTodo(ctx: viewContext, text: "Cook cake")
		buildTodo(ctx: viewContext, text: "Buy dogge coin", done: true)
		do {
			try viewContext.save()
		} catch {
			viewContext.rollback()
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
		return result
	}()

	private static func buildTodo(ctx: NSManagedObjectContext,
								  text: String,
								  done: Bool = false) -> Void {
		let todo = Todo(context: ctx)
		todo.id = UUID()
		todo.text = text
		todo.done = done
	}
}
