//
//  CopyNotesSandboxApp.swift
//  CopyNotesSandbox
//
//  Created by Clive on 29/06/2024.
//

import SwiftUI

@main
struct CopyNotesSandboxApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(noteController: NoteModelController())
        }.commands {
            SidebarCommands()
            
            }
    }
}

//class EnteredText: ObservableObject {
//    @Published var enteredText: String = "Initial Text"
//}
