//
//  PersistentContainer.swift
//  CopyNotesSandbox
//
//  Created by Clive on 18/08/2024.
//

import Foundation

import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
}
