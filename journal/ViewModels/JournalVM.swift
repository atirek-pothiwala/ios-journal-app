//
//  JournalVM.swift
//  journal
//
//  Created by Atirek Pothiwala on 17/07/25.
//

import Foundation
import CoreData

class JournalVM: ObservableObject {
    private let context: NSManagedObjectContext
    @Published var entries: [EntryItem] = []
    
    var hasEntries: Bool {
        return !entries.isEmpty
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchEntries()
    }
    
    func createEntry(_ date: Date, _ text: String) {
        let item = context.createEntry()
        updateEntry(item, date, text)
    }
    
    func updateEntry(_ item: EntryItem, _ date: Date, _ text: String) {
        item.timestamp = date
        item.text = text
        save()
    }

    func fetchEntries() {
        self.entries = context.fetchEntries()
    }
    
    func deleteEntry(_ offsets: IndexSet) {
        offsets.map { entries[$0] }.forEach(context.delete)
        context.trySave()
    }

    private func save() {
        context.trySave()
        fetchEntries()
    }
}
