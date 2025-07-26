//
//  JournalCell.swift
//  journal
//
//  Created by Atirek Pothiwala on 17/07/25.
//

import SwiftUI
import CoreData

struct JournalCell: View {
    @Binding var entry: JournalEntry
    let onViewImage: OnViewImage?
    
    init(_ entry: Binding<JournalEntry>, onViewImage: OnViewImage?) {
        _entry = entry
        self.onViewImage = onViewImage
    }
        
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            if let dt = entry.timestamp {
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
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                if let images = entry.images?.decodeArray() {
                    ImagePagination.CompactView(images: Binding.constant(images), max: 5, onViewImage: onViewImage)
                }
                
                if let text = entry.text {
                    Text(text)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundStyle(Color.main)
                        .font(.footnote)
                        .lineLimit(3)
                }
            }
        }
        .padding(.vertical, 10)
    }
}
