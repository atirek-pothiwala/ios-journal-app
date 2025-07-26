//
//  HomePage.swift
//  journal
//
//  Created by Atirek Pothiwala on 17/07/25.
//

import SwiftUI
import CoreData

struct HomePage: View {
    
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.managedObjectContext) private var context: NSManagedObjectContext
    @StateObject private var vm: HomeVM = HomeVM()
    
    var body: some View {
        ZStack {
            if vm.hasEntries {
                List {
                    ForEach($vm.entries, id: \.self) { entry in
                        Button {
                            withAnimation {
                                navigator.push(Route.add(entry.wrappedValue))
                            }
                        } label: {
                            JournalCell(entry) { index in
                                guard let images = entry.wrappedValue.images?.decodeArray(), !images.isEmpty else {
                                    return
                                }
                                withAnimation {
                                    navigator.push(Route.viewer(images, index))
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        withAnimation {
                            vm.deleteEntry(context, indexSet)
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    vm.fetchEntries(context)
                }
            } else {
                VStack(alignment: .center, spacing: 10) {
                    Image(systemName: "books.vertical")
                        .font(.largeTitle)
                    Text("Your journal is empty!")
                        .font(.subheadline)
                        .italic()
                }
                .foregroundStyle(Color.main)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: vm.hasEntries ? .topLeading : .center)
        .safeAreaPadding(.vertical)
        .navigationTitle(Text("My Journal"))
        .navigationBarTitleDisplayMode(.large)
        .tint(Color.black)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                btnAdd
            }
        }
        .onAppear {
            vm.fetchEntries(context)
        }
    }
    
    var btnAdd: some View {
        Button {
            navigator.push(Route.add())
        } label: {
            Image(systemName: "plus.app")
                .foregroundStyle(Color.main)
        }
        .buttonStyle(.plain)
        .font(.title)
    }
}
