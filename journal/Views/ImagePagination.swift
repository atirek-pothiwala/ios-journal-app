//
//  ImagePagination.swift
//  journal
//
//  Created by Atirek Pothiwala on 25/07/25.
//

import UIKit
import SwiftUI

typealias OnPickImage = () -> Void
typealias OnViewImage = (Int) -> Void

struct ImagePagination: View {
    
    @Binding var images: [String]
    @Binding var deletes: [String]
    let max: Int
    let size: Double
    let onPickImage: OnPickImage?
    let onViewImage: OnViewImage?
    
    static func DefaultView(images: Binding<[String]>,
                            deletes: Binding<[String]> = Binding.constant([]),
                            max: Int = 5,
                            onPickImage: OnPickImage? = nil) -> some View {
        return ImagePagination(images, deletes, max: max, size: 80, onPickImage: onPickImage)
    }
    
    static func CompactView(images: Binding<[String]>,
                            max: Int = 5,
                            onPickImage: OnPickImage? = nil,
                            onViewImage: OnViewImage? = nil) -> some View {
        return ImagePagination(images, max: max, size: 40, onPickImage: onPickImage, onViewImage: onViewImage)
    }
    
    private var rows: [GridItem] {
        return [
            GridItem(.fixed(size))
        ]
    }
    
    private var radius: Double {
        return size / 10
    }
    
    private var spacing: Double {
        return size / 5
    }
    
    private var isPaginationEnable: Bool {
        return onPickImage != nil
    }
    
    init(_ images: Binding<[String]>,
         _ deletes: Binding<[String]> = Binding.constant([]),
         max: Int = 5,
         size: Double = 80,
         onPickImage: OnPickImage? = nil,
         onViewImage: OnViewImage? = nil) {
        
        _images = images
        _deletes = deletes
        self.max = max
        self.size = size
        self.onPickImage = onPickImage
        self.onViewImage = onViewImage
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: spacing) {
                
                ForEach(images.indices, id: \.self) { index in
                    if let uiImage = images[index].loadImageFromDocuments() {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(RoundedRectangle(cornerRadius: radius))
                            .clipped()
                            .onTapGesture {
                                if isPaginationEnable {
                                    deletes.append(images.remove(at: index))
                                } else {
                                    onViewImage?(index)
                                }
                            }
                    } else {
                        RoundedRectangle(cornerRadius: radius)
                            .fill(Color.gray.opacity(0.25))
                            .frame(width: size, height: size)
                            .overlay {
                                Image(systemName: "xmark")
                                    .foregroundStyle(Color.black)
                            }
                            .onTapGesture {
                                deletes.append(images.remove(at: index))
                            }
                            .disabled(!isPaginationEnable)
                    }
                }
                
                if onPickImage != nil && images.count < max  {
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(lineWidth: 2)
                        .fill(Color.orange)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundStyle(Color.orange)
                        }
                        .onTapGesture {
                            onPickImage?()
                        }
                }
            }
        }
        .scrollIndicators(.never)
        .scrollDisabled(!isPaginationEnable)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
