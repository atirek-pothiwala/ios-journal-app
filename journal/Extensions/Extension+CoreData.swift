//
//  Extension+CoreData.swift
//  journal
//
//  Created by Atirek Pothiwala on 23/07/25.
//

import CoreData

extension NSManagedObjectContext {
    func createEntry() -> EntryItem {
        let newEntry = EntryItem(context: self)
        newEntry.id = UUID()
        newEntry.timestamp = Date()
        return newEntry
    }
    
    func fetchEntries() -> [EntryItem] {
        var entries: [EntryItem] = []
        do {
            let request: NSFetchRequest<EntryItem> = EntryItem.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \EntryItem.timestamp, ascending: false)
            ]
            entries = try self.fetch(request)
        } catch let e as NSError {
            print("Error: \(e), \(e.userInfo)")
            entries = []
        }
        return entries
    }
    
    func trySave() {
        do {
            try self.save()
        } catch let e as NSError {
            print("Error: \(e), \(e.userInfo)")
        }
    }
}
