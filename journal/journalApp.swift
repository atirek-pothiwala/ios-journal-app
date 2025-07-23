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
            HomePage(persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
