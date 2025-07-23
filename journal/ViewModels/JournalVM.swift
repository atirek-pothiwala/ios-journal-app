//
//  ListVM.swift
//  journal
//
//  Created by Atirek Pothiwala on 17/07/25.
//

import Foundation
import SwiftUI
import CoreData

class ListVM: ObservableObject {
    private let context: NSManagedObjectContext
    @Published var entries: [EntryItem] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchEntries()
    }

    func fetchEntries() {
        do {
            let request: NSFetchRequest<EntryItem> = EntryItem.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \EntryItem.timestamp, ascending: false)
            ]
            entries = try context.fetch(request)
        } catch let e as NSError {
            entries = []
            print("Fetch Error: \(e), \(e.userInfo)")
        }
    }

    func addEntry(text: String) {
        let newEntry = EntryItem(context: context)
        newEntry.id = UUID()
        newEntry.text = text
        newEntry.timestamp = Date()
        
        save()
    }

    private func save() {
        do {
            try context.save()
            fetchEntries()
        } catch let e as NSError {
            print("Save Error: \(e), \(e.userInfo)")
        }
    }
}
