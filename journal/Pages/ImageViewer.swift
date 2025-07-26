//
//  ImageViewer.swift
//  journal
//
//  Created by Atirek Pothiwala on 26/07/25.
//


import SwiftUI
import CoreData

struct ImageViewer: View {
    
    @EnvironmentObject var navigator: Navigator
    let images: [UIImage]

    @State private var selectedIndex = 0
    
    init(_ images: [String], _ index: Int) {
        self.selectedIndex = index
        self.images = images.compactMap { path in
            return path.loadImageFromDocuments()
        }
    }

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onAppear {
            let appearance = UIPageControl.appearance()
            appearance.currentPageIndicatorTintColor = UIColor.main
            appearance.pageIndicatorTintColor = UIColor.main.withAlphaComponent(0.2)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        navigator.pop()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.main)
                }
            }
        }
    }
}
