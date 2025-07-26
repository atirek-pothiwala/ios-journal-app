//
//  AddVM.swift
//  journal
//
//  Created by Atirek Pothiwala on 25/07/25.
//

import Foundation
import CoreData
import UIKit

class AddVM: ObservableObject {
    var entry: JournalEntry?
    
    @Published var timestamp: Date = Date()
    @Published var text: String = ""
    @Published var images: [String] = []
    @Published var deletes: [String] = []
    
    let minCharacters: Int = 100
    let maxImages: Int = 5
    
    var hasMaxImages: Bool {
        return images.count >= maxImages
    }
    
    var checkImages: String {
        return "Max \(maxImages) Photos"
    }
    
    var hasMinCharacters: Bool {
        return text.count >= minCharacters
    }
    
    var checkCharacters: String {
        return "Minimum Characters: \(text.count)/\(minCharacters)"
    }
    
    init(_ entry: JournalEntry? = nil) {
        self.entry = entry
        self.timestamp = entry?.timestamp ?? Date()
        self.text = entry?.text ?? ""
        self.images = entry?.images?.decodeArray() ?? []
    }
    
    func save(_ context: NSManagedObjectContext) {
        do {
            deletes.forEach { image in
                image.deleteImageFromDocuments()
            }
            
            if entry == nil {
                entry = JournalEntry(context: context)
            }
            entry?.timestamp = timestamp
            entry?.text = text
            entry?.images = images.encodeArray()
            
            try context.save()
        } catch (let e as NSError) {
            print("Error: \(e), \(e.userInfo)")
        }
    }
}
