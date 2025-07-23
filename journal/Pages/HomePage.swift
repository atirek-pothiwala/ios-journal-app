//
//  ListPage.swift
//  journal
//
//  Created by Atirek Pothiwala on 17/07/25.
//

import SwiftUI
import CoreData

struct HomePage: View {
    
    @StateObject private var vm: JournalVM
    @State private var editMode: EditMode = .inactive
    var isEditMode: Bool { editMode.isEditing }
    
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
            .environment(\.editMode, $editMode)
            .safeAreaPadding(.vertical)
            .navigationTitle(
                Text("Journal Book")
                    .foregroundStyle(Color.main)
            )
            .navigationBarTitleDisplayMode(.large)
            .tint(Color.black)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    btnAdd
                }
                ToolbarItem(placement: .topBarTrailing) {
                    btnDelete
                }
            }
        }
    }
    
    var btnAdd: some View {
        NavigationLink {
            AddPage(listener: self)
        } label: {
            Image(systemName: "plus.app.fill")
                .foregroundStyle(Color.main)
        }
        .buttonStyle(.plain)
        .font(.title)
        .disabled(isEditMode)
    }
    
    var btnDelete: some View {
        Button {
            withAnimation {
                editMode = isEditMode ? .inactive : .active
            }
        } label: {
            Image(systemName: isEditMode ? "trash.slash.square.fill" : "trash.square.fill")
                .foregroundStyle(isEditMode ? Color.green : Color.main)
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
