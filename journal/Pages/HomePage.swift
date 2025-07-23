//
//  HomePage.swift
//  journal
//
//  Created by Atirek Pothiwala on 17/07/25.
//

import SwiftUI
import CoreData

struct HomePage: View {
    
    @StateObject private var vm: JournalVM
    
    init(_ context: NSManagedObjectContext) {
        _vm = StateObject(
            wrappedValue: JournalVM(context: context)
        )
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if vm.hasEntries {
                    List {
                        ForEach($vm.entries) { item in
                            NavigationLink {
                                AddPage(entryItem: item.wrappedValue, listener: self)
                            } label: {
                                JournalCell(item: item)
                            }
                        }
                        .onDelete { indexSet in
                            withAnimation {
                                vm.deleteEntry(indexSet)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        vm.fetchEntries()
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
            .navigationTitle(
                Text("Journal Book")
            )
            .navigationBarTitleDisplayMode(.large)
            .tint(Color.black)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    btnAdd
                }
            }
        }
    }
    
    var btnAdd: some View {
        NavigationLink {
            AddPage(listener: self)
        } label: {
            Image(systemName: "plus.app")
                .foregroundStyle(Color.main)
        }
        .buttonStyle(.plain)
        .font(.title)
    }
}

extension HomePage: OnNoteListener {
    func onSave(entryItem: EntryItem?, date: Date, text: String) {
        if entryItem != nil {
            vm.updateEntry(entryItem!, date, text)
        } else {
            vm.createEntry(date, text)
        }
    }
}

#Preview {
    HomePage(PersistenceController.shared.container.viewContext)
}
