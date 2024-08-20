//
//  ContentView.swift
//  CopyNotesSandbox
//
//  Created by Clive on 29/06/2024.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    // At the moment selectedIndex is not an index, it's a note object.
    @State private var selectedIndex: Note?
    @State private var searchText = ""
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Note.num, ascending: true)]) var notes: FetchedResults<Note>
    
    let context = PersistenceController.shared.container.viewContext
    
    var body: some View {
        NavigationView {
            VStack{
                SearchBar(text: $searchText)
                List(selection: $selectedIndex) {
                    ForEach(filteredNotes) {note in
                        Button(action: {
                            selectedIndex = note
                            copyToClipboard(bodyText: note.bodyText ?? "")
                            print(selectedIndex)
                        }) {
                            TableRowView(note: note).frame(maxWidth: .infinity, alignment: .leading)
                                .padding(5)
                        }
                        
                        // I don't for the life of me understand why, but adding this custom buttonStyle allows me to change the width of the button using frame to fill the whole row
                        .buttonStyle(BlueButtonStyle())
                        // This adds an option to right click and delete, but not sure how to ensure this is the selected item
                        .contextMenu {
                            Button(action: {
                                deleteSelectedNote(deletedNote: note)
                            }){
                                Text("Delete")
                            }
                        }
                        
                    }
                    // TODO: Maybe create a new method moveNotes for this?
                    .onMove(perform: moveNotes)
                    
                    
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 250, maxWidth: 350)
                .toolbar {
                    ToolbarItemGroup{
                        Spacer()
                        Button(action: {
                            withAnimation {
                                addNote()
                            }
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24.0, height: 24.0)
                        }
                    }
                }
            }
            if let selectedNote = selectedIndex {
                DetailView(note: Binding(get: {
                    selectedNote
                }, set: { newValue in
                    // Instead of replacing the note in the array, update its properties
                    
                    //TODO 20/08/2024: This is detailview is never getting called when selecting a sidebar thing
                    print("this is newValue: ", newValue)
                    
                    selectedNote.title = newValue.title
                    selectedNote.bodyText = newValue.bodyText
                    selectedNote.dateCreated = newValue.dateCreated
                    selectedNote.num = newValue.num
                    selectedNote.headerText = newValue.headerText
                    
                    // Save the context to persist the changes
                    //                    let context = PersistenceController.shared.container.viewContext
                    do {
                        try context.save()
                    } catch {
                        print("Failed to save updated note: \(error)")
                    }
                    
                    // Update selectedIndex to the new value if necessary
                    selectedIndex = newValue
                    
                }), function: {self.deleteSelectedNote(deletedNote: selectedNote)})
            } else {
                Text("Pick a note")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .navigationTitle("Snippets")
        .frame(maxWidth: 900, maxHeight: 600)
        .onAppear {
            //            self.readCodes()
        }
    }
    
    // Filtered notes based on the search text
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return Array(notes)
        } else {
            return notes.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    
    
    //    private func deleteNote(at offsets: IndexSet) {
    //        //        This function deletes notes from the notes array at the specified offsets and then checks if any of the deleted notes were the currently selected note. If the selected note was deleted, it sets selectedNote to nil.
    //        // Testing from the test project, this function actually doesn't get called, it seems onDelete only gets called if the user swipes to delete
    //
    //        noteController.dummyArray.remove(atOffsets: offsets)
    //        if let selectedIndex = selectedIndex, offsets.contains(where: {  noteController.dummyArray[$0].id == selectedIndex.id }) {
    //            self.selectedIndex = nil
    //        }
    //    }
    
    // TODO: 13 Jul 2024, updated add and delete buttons, try the removeoffsets method for delete from the testnotesproject as that is maybe updating the indices immediately.
    
    private func addNote() {
        
        let count = notes.count
        
        if notes.count < 6 {
            
            //            let context = PersistenceController.shared.container.viewContext
            let newNote = Note(context: context)
            
            newNote.title = "New Updated Title"
            newNote.bodyText = "description"
            newNote.dateCreated = Date()
            newNote.num = Int32(count+1)
            newNote.id = UUID()
            newNote.headerText = "Section 1"
            
            do {
                try context.save()
                selectedIndex = newNote
                print("new note created")
                print("count ", notes.count)
                print(notes)
                
            } catch {
                print("Failed to save note: \(error)")
            }
            renumberNotes()
        }
        
        
        
        // old code in the old button
        //        let newNote = Note(nr: (noteController.dummyArray.count + 1), headerCode: "3", headerText: "Section 1", title: "New Updated Title", bodyText: "description")
        //
        //        if noteController.dummyArray.count < 6 {
        //            noteController.dummyArray.append(newNote)
        //        }
        //
    }
    
    private func deleteSelectedNote(deletedNote: Note) {
        context.delete(deletedNote)
        
        // renumber
        //        var i = 0
        //        for note in notes {
        //            if note == deletedNote {
        //                continue
        //            } else {
        //            note.num = Int32(i+1)
        //            print("renumbering: ", i+1)
        //            i += 1
        //            }
        //        }
        //        i = 0
        
        do {
            try context.save()
            print("note deleted, now notes are: ")
            print("count ", notes.count)
            print(notes)
            
        } catch {
            print("Failed to delete note: \(error)")
        }
        
        renumberNotes()
        
    }
    
    private func renumberNotes() {
        var i: Int32 = 1
        for note in notes.sorted(by: { $0.num < $1.num }) {
            note.num = i
            i += 1
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to renumber notes: \(error)")
        }
    }
    
    
    
    private func moveNotes(from source: IndexSet, to destination: Int) {
        var reorderedNotes = notes.sorted { $0.num < $1.num }
        reorderedNotes.move(fromOffsets: source, toOffset: destination)
        
        for (index, note) in reorderedNotes.enumerated() {
            note.num = Int32(index + 1)
        }
        
        let context = PersistenceController.shared.container.viewContext
        do {
            try context.save()
        } catch {
            print("Failed to move notes: \(error)")
        }
    }
    
}

private func copyToClipboard(bodyText: String) {
    //        if selectedIndex?.bodyText != nil {
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(bodyText, forType: .string)
    //        } else {
    //            print("selected Index is nil" )
    //        }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct TableRowView: View {
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(note.num). \(note.title ?? "New Title")")
            //                .frame(width: 100)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Text(note.bodyText ?? "")
                .fontWeight(.light)
                .truncationMode(.tail)
            
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

// keeping this in in case I want to add sections

struct SectionHeaderView: View {
    var section: Note
    let sectionNumber: Int
    
    var body: some View {
        HStack(spacing: 20) {
            Text("\(sectionNumber)")
                .layoutPriority(1)
            Text(section.headerText ?? "Section Header")
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
            
        }
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
