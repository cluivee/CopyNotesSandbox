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
    
    var exampleNote: Note = Note(headerCode: "3", headerText: "Section 1", code: "code 202", title: "New Updated Title", bodyText: "description")
    //    @State private var showSamplesSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List($noteController.dummyArray, selection: $selectedIndex) {$section in
                    NavigationLink(destination: DetailView(noteSection: $section).onAppear{
                        
                        selectedIndex = section
                        print("\(String(describing: selectedIndex!.bodyText))")
                        copyToClipboard(bodyText: section.bodyText)
                        
                    }) {
                        TableRowView(note: $section)
                    }
                    
                }.frame(minWidth: 250, maxWidth: 350)
                Button("Copy First") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString("\(selectedIndex!.bodyText)", forType: .string)
                }
            }
        }
        .listStyle(SidebarListStyle())
        .frame(maxWidth: 900, maxHeight: 600)
        .onAppear {
            //            self.readCodes()
        }
        
    }
    private func copyToClipboard(bodyText: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(bodyText, forType: .string)
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
            Text(note.title)
            //                .frame(width: 100)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(note.bodyText)
                .truncationMode(.tail)
            
            Spacer()
            
        }.multilineTextAlignment(.leading)
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
