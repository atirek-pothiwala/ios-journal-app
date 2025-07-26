//
//  AddNotesPage.swift
//  journal
//
//  Created by Atirek Pothiwala on 18/07/25.
//

import SwiftUI
import UIKit
import CoreData


struct AddPage: View {
    
    @EnvironmentObject private var navigator: Navigator
    @Environment(\.managedObjectContext) private var context: NSManagedObjectContext
    @StateObject private var vm: AddVM
    
    @State private var showPicker: Bool = false
    
    init(_ entry: JournalEntry? = nil) {
        _vm = StateObject(
            wrappedValue: AddVM(entry)
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                DatePicker(selection: $vm.timestamp, displayedComponents: .date, label: {
                    sectionTitle(
                        title: "Entry Date",
                        systemImage: "calendar"
                    )
                })
                .datePickerStyle(.compact)
                .font(.headline)
                .tint(.orange)
                
                divider
                                    
                sectionTitle(
                    title: "Attachment (\(vm.checkImages))",
                    systemImage: "photo.fill"
                )
                
                ImagePagination.DefaultView(
                    images: $vm.images,
                    deletes: $vm.deletes,
                    max: vm.maxImages) {
                    showPicker.toggle()
                }
                
                divider
                
                sectionTitle(
                    title: "Enter Notes",
                    systemImage: "pencil.and.list.clipboard"
                )
                
                TextEditor(text: $vm.text)
                    .keyboardType(.alphabet)
                    .textEditorStyle(.plain)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .aspectRatio(1, contentMode: .fit)
                    .font(.title3)
                    .tint(Color.orange)
                    .padding(.all, 10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orange, lineWidth: 1.5)
                    }
                
                HStack(alignment: .center) {
                    Spacer()
                    
                    Text(vm.checkCharacters)
                        .font(.footnote)
                        .foregroundStyle(vm.hasMinCharacters ? Color.green : Color.main)
                }
            }
        }
        .scrollIndicators(.never)
        .foregroundStyle(Color.main)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaPadding(.all)
        .fullScreenCover(isPresented: $showPicker) {
            withAnimation {
                ImagePicker(sourceType: .photoLibrary) { image in
                    Task {
                        if let fileName = image.saveToDocuments() {
                            await MainActor.run {
                                vm.images.append(fileName)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(Text("Journal Entry"))
        .tint(Color.black)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                btnBack
            }
            ToolbarItem(placement: .topBarTrailing) {
                btnDone
            }
        }
    }
    
    var btnBack: some View {
        Button {
            withAnimation {
                navigator.pop()
            }
        } label: {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "chevron.backward")
                Text("My Journal")
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color.main)
        .font(.title3)
    }
    
    var btnDone: some View {
        Button {
            Task {
                vm.save(context)
                await MainActor.run {
                    withAnimation {
                        navigator.pop()
                    }
                }
            }
        } label: {
            Image(systemName: "checkmark")
                .background {
                    if vm.hasMinCharacters {
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
        .disabled(!vm.hasMinCharacters)
    }
    
    var divider: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: 2)
            .foregroundStyle(Color.orange)
            .ignoresSafeArea()
    }
    
    func sectionTitle(title: String, systemImage: String) -> some View {
        HStack(alignment: .center, spacing: 7.5) {
            Image(systemName: systemImage)
            Text(title)
        }
        .font(.headline)
    }
}

