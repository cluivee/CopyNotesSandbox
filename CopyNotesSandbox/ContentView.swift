//
//  OldContentView.swift
//  CopyNotesSandbox
//
//  Created by Clive on 29/06/2024.
//

import Foundation
import SwiftUI


struct ContentView: View {
    @StateObject var noteController: NoteModelController
    @State private var selectedIndex: Note?
    
    // exampleNote is not currently used
    //    var exampleNote: Note = Note(nr: 1, headerCode: "3", headerText: "Section 1", title: "New Updated Title", bodyText: "description")
    //    @State private var showSamplesSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(selection: $selectedIndex) {
                    ForEach($noteController.dummyArray) { $listItem in
            
                        Button(action: {
                            selectedIndex = listItem
                            copyToClipboard(bodyText: listItem.bodyText)
                            print("\(String(describing: selectedIndex!.bodyText))")
                        }) {
                            TableRowView(note: $listItem).frame(maxWidth: .infinity, alignment: .leading)
                        }
                    
                    // I don't for the life of me understand why, but adding this custom buttonStyle allows me to change the width of the button using frame to fill the whole row
                        .buttonStyle(BlueButtonStyle())
                        // This adds an option to right click and delete, but not sure how to ensure this is the selected item
                        .contextMenu {
                            Button(action: deleteSelectedNote){
                                Text("Delete")
                            }
                        }
//                    NavigationLink(destination: DetailView(noteSection: $section).onAppear{
//
//                        selectedIndex = section
//                        print("\(String(describing: selectedIndex!.bodyText))")
//                        copyToClipboard(bodyText: section.bodyText)
//
//                    }) {
//                        TableRowView(note: $section)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .contentShape(Rectangle())
//                    .border(.green)
                    }
                    .onMove { indexSet, newOffset in
                        print("onMove called")
                        noteController.dummyArray.move(fromOffsets: indexSet, toOffset: newOffset)
                        // renumber
                        for i in 0..<noteController.dummyArray.count {
                            noteController.dummyArray[i].nr = i+1
                        }

                    }

                }
                .frame(minWidth: 250, maxWidth: 350)
                
                // The buttons
                HStack {
                    Button(action: addNote) {
                        Text("Add Note")
                        
                    }
                    Button(action: deleteSelectedNote) {
                        Text("Delete Selected")
                        
                    }
                }
            }
            
            if let selectedNote = selectedIndex {
                DetailView(noteSection: Binding(get: {
                    selectedNote
                }, set: { newValue in
                    if let index = noteController.dummyArray.firstIndex(where: { $0.id == newValue.id }) {
                        noteController.dummyArray[index] = newValue
                        selectedIndex = newValue
                    }
                }))
            } else {
                Text("Pick a note")
                    .foregroundColor(.gray)
                    .padding()
            }
            
        }
        .listStyle(SidebarListStyle())
        .frame(maxWidth: 900, maxHeight: 600)
        .onAppear {
            //            self.readCodes()
        }
        
    }
    
    private func deleteNote(at offsets: IndexSet) {
//        This function deletes notes from the notes array at the specified offsets and then checks if any of the deleted notes were the currently selected note. If the selected note was deleted, it sets selectedNote to nil.
// Testing from the test project, this function actually doesn't get called, it seems onDelete only gets called if the user swipes to delete
        
        
        noteController.dummyArray.remove(atOffsets: offsets)
        if let selectedIndex = selectedIndex, offsets.contains(where: {  noteController.dummyArray[$0].id == selectedIndex.id }) {
            self.selectedIndex = nil
        }
    }
    // TODO: 13 Jul 2024, updated add and delete buttons, try the removeoffsets method for delete from the testnotesproject as that is maybe updating the indices immediately.
    
    private func addNote() {
        let count = noteController.dummyArray.count
        let newNote = Note(nr: count + 1,  headerCode: "3", headerText: "Section 1", title: "New Updated Title", bodyText: "description")
        
        if noteController.dummyArray.count < 6 {
                    noteController.dummyArray.append(newNote)
                }
            
        selectedIndex = newNote
        
        // old code in the old button
//        let newNote = Note(nr: (noteController.dummyArray.count + 1), headerCode: "3", headerText: "Section 1", title: "New Updated Title", bodyText: "description")
//
//        if noteController.dummyArray.count < 6 {
//            noteController.dummyArray.append(newNote)
//        }
//
    }
    
    private func deleteSelectedNote() {
        if let deletedIndex = selectedIndex {
            noteController.dummyArray.removeAll { $0.id == deletedIndex.id }
            self.selectedIndex = nil
            // renumber
            for i in 0..<noteController.dummyArray.count {
                noteController.dummyArray[i].nr = i+1
            }
        }
        // old code in the old button
//        if noteController.dummyArray.count > 0  {
//            noteController.dummyArray.removeLast()
//        }
    }
    
    private func copyToClipboard(bodyText: String) {
        if selectedIndex?.bodyText != nil {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(bodyText, forType: .string)
        } else {
            print("selected Index is nil" )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(noteController: NoteModelController())
    }
}

struct SectionHeaderView: View {
    var section: Note
    let sectionNumber: Int
    
    var body: some View {
        HStack(spacing: 20) {
            Text("\(sectionNumber)")
                .layoutPriority(1)
            Text(section.headerText)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
            
        }
    }
}

struct TableRowView: View {
    @Binding var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(note.nr) - \(note.title)")
            //                .frame(width: 100)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(note.bodyText)
                .truncationMode(.tail)
            
            Spacer()
            
        }.multilineTextAlignment(.leading)
    }
}

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.blue : Color.white)
            .background(configuration.isPressed ? Color.white : Color.blue)
            .cornerRadius(6.0)
            .padding(1)
    }
}

// If I want to add sections later

//Section(header: SectionHeaderView(section: exampleNote, sectionNumber: 1)) {
//}

// Things  I tried to add to tablerowview to get it to click

//{
//    TableRowView(note: $section)
//}
//                        .simultaneousGesture(TapGesture().onEnded {
//                            selection = section
//                            print(selection)
//                        })
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        selection = section
//                        print(selection)
//                    }


// The old implementation of NavigationView just for reference

//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(Array(zip(noteController.indices, noteController)), id: \.0) { index, section in
//                    Section(header: SectionHeaderView(section: section, sectionNumber: (index+1))) {
//                        NavigationLink(destination: DetailView(noteSection: section)) {
//                            TableRowView(status: section)
//                        }
//                    }
//                }
//            }
//            .frame(minWidth: 250, maxWidth: 350)
//        }
//        .listStyle(SidebarListStyle())
//        .frame(maxWidth: 900, maxHeight: 600)
//        .onAppear {
//        }
//    }

//}
