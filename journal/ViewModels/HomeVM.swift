//
//  HomeVM.swift
//  journal
//
//  Created by Atirek Pothiwala on 17/07/25.
//

import Foundation
import CoreData

class HomeVM: ObservableObject {
    @Published var entries: [JournalEntry] = []
    
    var hasEntries: Bool {
        return !entries.isEmpty
    }

    func fetchEntries(_ context: NSManagedObjectContext) {
        Task {
            let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \JournalEntry.timestamp, ascending: false)
            ]
            let entries = try context.fetch(request)
            await MainActor.run {
                self.entries = entries
            }
        }
    }
    
    func deleteEntry(_ context: NSManagedObjectContext, _ offsets: IndexSet) {
        Task {
            offsets.map { entries[$0] }.forEach(context.delete)
            try context.save()
            
            await MainActor.run {
                entries.remove(atOffsets: offsets)
            }
        }
    }
}
