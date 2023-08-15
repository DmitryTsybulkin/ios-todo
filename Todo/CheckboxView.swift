//
//  TodoListElementView.swift
//  Todo
//
//  Created by Dmitry Tsybulkin on 2023-08-02.
//

import SwiftUI
import CoreData

struct CheckboxView: View {
	
	@Environment(\.managedObjectContext)
	private var viewContext: NSManagedObjectContext
	
	@State var id: UUID
	@Binding var checked: Bool
	
	var body: some View {
			Image(systemName: checked ? "checkmark.square.fill" : "square")
				.foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
				.onTapGesture {
					markDone()
				}
	}
	
	private func markDone() {
		do {
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
			request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
			do {
				let todo = (try? viewContext.fetch(request) as? [Todo])?.first
				if todo == nil {
					print("Failed to get todo by id: \(id)")
				}
				todo?.done = todo!.done ? false : true
				try viewContext.save()
			} catch {
				viewContext.rollback()
				let error = error as NSError
				fatalError(error.localizedDescription)
			}
		}
	}
}
