//
//  Navigator.swift
//  recipes
//
//  Created by Atirek Pothiwala on 06/04/25.
//


import SwiftUI

class Navigator: ObservableObject {
    @Published var path = NavigationPath()

    func reset() {
        path.removeLast(path.count)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func push<T: Hashable>(_ value: T) {
        path.append(value)
    }
}
