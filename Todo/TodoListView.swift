//
//  ContentView.swift
//  Todo
//
//  Created by Dmitry Tsybulkin on 2023-07-31.
//

import SwiftUI
import CoreData

struct TodoListView: View {
	
    @Environment(\.managedObjectContext)
	private var viewContext: NSManagedObjectContext
	
	private let TOTAL_MSG_FORMAT = "%i incompleted, %i completed"
	
	private var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM d, yyyy"
		return formatter
	}
	
    @FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Todo.id, ascending: true)],
        animation: .default)
    private var todos: FetchedResults<Todo>

	var body: some View {
		NavigationStack {
			VStack {
				Text(
					String(
						format: TOTAL_MSG_FORMAT,
						filterTodos { !$0.done }.count,
						filterTodos { $0.done }.count
					)
				)
				.foregroundColor(.gray)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(
					EdgeInsets(
						top: 0,
						leading: 20,
						bottom: 0,
						trailing: 0
					)
				)
				Divider()
				Section {
					Text("Incompleted")
						.font(.title)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(
							EdgeInsets(
								top: 0,
								leading: 25,
								bottom: 0,
								trailing: 0
							)
						)
						.background(.clear)
					todoListView(filterTodos { !$0.done })
						.navigationTitle(getDate())
						.toolbar {
							ToolbarItem {
								NavigationLink(destination: TodoEditView(passedTodo: nil)) {
									Label("Add todo", systemImage: "plus")
								}
							}
						}
				}.padding(
					EdgeInsets(
						top: 0, leading: 0, bottom: 0, trailing: 0
					)
				)
				
				Text("Completed")
					.font(.title)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(
						EdgeInsets(
							top: 0,
							leading: 25,
							bottom: 0,
							trailing: 0
						)
					)
				todoListView(filterTodos { $0.done })
			}
		}
	}
	
	private func todoListView(_ todos: [Todo]) -> some View {
		return List {
			ForEach(todos) { todo in
				NavigationLink(destination: TodoEditView(passedTodo: todo)) {
					TodoListElement(todo: todo)
				}
			}
			.onDelete(perform: self.deleteTodo)
		}
		.listRowSeparator(.hidden)
		.listRowBackground(
			RoundedRectangle(cornerRadius: 10)
				.background(.clear)
				.padding(
					EdgeInsets(
						top: 2,
						leading: 10,
						bottom: 2,
						trailing: 10
					)
				)
		)
	}
	
	private func deleteTodo(_ idx: IndexSet) {
		withAnimation {
			let todo: Todo? = idx.map {
				todos[$0]
			}.first
			if (todo != nil) {
				viewContext.delete(todo!)
			}
			do {
				try viewContext.save()
			} catch {
				print("Failed to save")
			}
		}
	}
	
	private func filterTodos(_ predicate: @escaping (Todo) -> Bool) -> [Todo] {
		return self.todos.filter(predicate)
	}
	
	private func getDate() -> String {
		dateFormatter.string(from: Date())
	}
}

struct TodoListView_Previews: PreviewProvider {
	static var previews: some View {
		TodoListView()
			.environment(\.managedObjectContext,
						  PersistenceController.preview.container.viewContext)
	}
}
