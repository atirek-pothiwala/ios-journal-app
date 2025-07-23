//
//  AddNotesPage.swift
//  journal
//
//  Created by Atirek Pothiwala on 18/07/25.
//

import SwiftUI

protocol OnNoteListener {
    func onSave(entryItem: EntryItem?, date: Date, text: String)
}

struct AddPage: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var entryDate: Date
    @State var entryText: String
    
    let entryItem: EntryItem?
    let listener: OnNoteListener?
    
    init(entryItem: EntryItem? = nil, listener: OnNoteListener?) {
        self.entryDate = entryItem?.timestamp ?? .now
        self.entryText = entryItem?.text ?? ""
        self.entryItem = entryItem
        self.listener = listener
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15) {
                DatePicker(selection: $entryDate, displayedComponents: .date, label: {
                    HStack(alignment: .center, spacing: 7.5) {
                        Image(systemName: "calendar")
                        Text("Entry Date")
                    }
                })
                .datePickerStyle(.compact)
                .font(.headline)
                .tint(.orange)
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 10)
                    .foregroundStyle(Color.orange)
                    .padding(.bottom, 10)
                    .ignoresSafeArea()
                
                HStack(alignment: .center, spacing: 7.5) {
                    Image(systemName: "pencil.and.list.clipboard")
                    Text("Enter Notes")
                }
                .font(.headline)
                
                TextEditor(text: $entryText)
                    .keyboardType(.alphabet)
                    .textEditorStyle(.plain)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .aspectRatio(1, contentMode: .fit)
                    .font(.title3)
                    .tint(Color.orange)
                    .padding(.all, 10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 1.5)
                    }
                
                Spacer()
            }
            .foregroundStyle(Color.main)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaPadding(.all)
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(Text("Journal Entry"))
        .tint(Color.black)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                btnDismiss
            }
            ToolbarItem(placement: .topBarTrailing) {
                btnDone
            }
        }
    }
    
    var btnDismiss: some View {
        Button {
            withAnimation {
                dismiss()
            }
        } label: {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "chevron.backward")
                Text("Journal Book")
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color.main)
        .font(.title3)
    }
    
    var btnDone: some View {
        Button {
            withAnimation {
                dismiss()
                listener?.onSave(entryItem: entryItem, date: entryDate, text: entryText)
            }
        } label: {
            Image(systemName: "checkmark")
                .background {
                    if !entryText.isEmpty {
                        Circle()
                            .fill(Color.gray.opacity(0.25))
                            .frame(width: 20, height: 20)
                    }
                }
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color.orange)
        .font(.title3)
        .bold()
        .disabled(entryText.isEmpty)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    if let item = context.fetchEntries().first {
        NavigationView {
            AddPage(entryItem: item, listener: nil)
        }
    }
}
