//
//  JournalCell.swift
//  journal
//
//  Created by Atirek Pothiwala on 17/07/25.
//

import SwiftUI
import CoreData

struct JournalCell: View {
    @Binding var item: EntryItem
        
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let dt = item.timestamp {
                VStack(alignment: .center, spacing: 0) {
                    Text(dt, format: .dateTime.day())
                        .font(.title)
                        .italic()
                    
                    Text(dt, format: .dateTime.month().year(.twoDigits))
                        .font(.subheadline)
                }
                .bold()
                .padding(.all, 10)
                .foregroundStyle(Color.white)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            if let text = item.text {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.vertical, 10)
                    .foregroundStyle(Color.main)
                    .font(.footnote)
                    .lineLimit(3)
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    if let item = context.fetchEntries().first {
        JournalCell(item: Binding.constant(item))
    }
}
