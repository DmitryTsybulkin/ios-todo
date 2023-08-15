//
//  TodoListElement.swift
//  Todo
//
//  Created by Dmitry Tsybulkin on 2023-08-02.
//

import SwiftUI
import CoreData

struct TodoListElement: View {
	
	@Environment(\.managedObjectContext)
	private var viewContext: NSManagedObjectContext
	
	@State var todo: Todo
	
	var body: some View {
		HStack {
			CheckboxView(id: $todo.id, checked: $todo.done)
			if (todo.done) {
				Text(todo.text)
					.foregroundColor(.gray)
					.strikethrough()
			} else {
				Text(todo.text)
			}
		}
	}
}
