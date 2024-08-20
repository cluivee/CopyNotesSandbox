//
//  CopyNotesSandboxApp.swift
//  CopyNotesSandbox
//
//  Created by Clive on 29/06/2024.
//

import SwiftUI

@main
struct CopyNotesSandboxApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }.commands {
            SidebarCommands()
            
            }
    }
}

//class EnteredText: ObservableObject {
//    @Published var enteredText: String = "Initial Text"
//}
