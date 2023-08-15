//
//  CardView.swift
//  Todo
//
//  Created by Dmitry Tsybulkin on 2023-07-31.
//

import SwiftUI
import CoreData

struct TodoEditView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.dismiss) var dismiss
	
	@State private var selectedTodo: Todo?
	@State private var text: String
	
	init(passedTodo: Todo?) {
		if let todo	= passedTodo {
			_selectedTodo = State(initialValue: todo)
			_text = State(initialValue: todo.text)
		} else {
			_text = State(initialValue: "")
		}
	}
	
	var body: some View {
		NavigationStack {
			Form {
				TextField("", text: $text, axis: .vertical)
					.textFieldStyle(.plain)
					.lineLimit(3, reservesSpace: true)
					.padding()
			}
			.navigationBarTitle("Task")
			
			Spacer()
			
			Button(action: saveTodo) {
				Text("Save")
					.padding(
						EdgeInsets(
							top: 7, leading: 0, bottom: 7, trailing: 0
						)
					)
					.font(.headline)
					.frame(maxWidth: 300)
			}
			.frame(maxWidth: .infinity)
			.buttonStyle(.borderedProminent)
		}
	}
	
	private func saveTodo() {
		withAnimation {
			if selectedTodo == nil {
				selectedTodo = Todo(context: viewContext)
				selectedTodo?.id = UUID()
			}
			selectedTodo?.text = text
			selectedTodo?.done = false
			saveContext(viewContext)
			self.presentationMode.wrappedValue.dismiss()
		}
	}
	
	private func saveContext(_ ctx: NSManagedObjectContext) {
		if ctx.hasChanges {
			do {
				try ctx.save()
			} catch {
				ctx.rollback()
				let error = error as NSError
				fatalError(error.localizedDescription)
			}
		}
	}
}

struct TodoEditView_Previews: PreviewProvider {
	static var previews: some View {
		TodoEditView(passedTodo: nil)
	}
}
