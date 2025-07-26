//
//  Route.swift
//  journal
//
//  Created by Atirek Pothiwala on 04/04/25.
//

import CoreData

enum Route: Hashable {
    case home
    case add(JournalEntry? = nil)
    case viewer([String], Int)
}
