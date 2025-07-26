//
//  RootNavigator.swift
//  recipes
//
//  Created by Atirek Pothiwala on 04/04/25.
//

import SwiftUI

struct RootNavigator: View {
    
    @StateObject private var navigator = Navigator()
    private let persistenceController = PersistenceController()

    var body: some View {
        NavigationStack(path: $navigator.path) {
            HomePage()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        HomePage()
                    case .add(let entry):
                        AddPage(entry)
                    case .viewer(let images, let index):
                        ImageViewer(images, selectedIndex: index)
                    }
                }
        }
        .environmentObject(navigator)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }

}
