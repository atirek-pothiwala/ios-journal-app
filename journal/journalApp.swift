//
//  journalApp.swift
//  journal
//
//  Created by Atirek Pothiwala on 17/07/25.
//

import SwiftUI

@main
struct journalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
