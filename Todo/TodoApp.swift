//
//  TodoApp.swift
//  Todo
//
//  Created by Dmitry Tsybulkin on 2023-07-31.
//

import SwiftUI

@main
struct TodoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
			let context = persistenceController.container.viewContext
            TodoListView()
				.environment(\.managedObjectContext, context)
        }
    }
}
