//
//  ContentView.swift
//  CopyNotesSandbox
//
//  Created by Clive on 29/06/2024.
//

import Foundation
import SwiftUI


struct ContentView: View {
    @StateObject var noteController: NoteModelController
    
    var exampleNote: Note = Note(headerCode: "3", headerText: "Section 1", code: "code 202", title: "New Updated Title", bodyText: "description")
//    @State private var showSamplesSheet = false
    
    var body: some View {

        NavigationView {
            List {
                ForEach($noteController.dummyArray) {$section in
                
                Section(header: SectionHeaderView(section: $section, sectionNumber: 1)) {
                        NavigationLink(destination: DetailView(noteSection: $section)) {
                            TableRowView(status: $section)
                        }
                    }
                }
                Button("Copy First") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(noteController.dummyArray[0].bodyText, forType: .string)
                }
                
                
            }
            .frame(minWidth: 250, maxWidth: 350)
            
        }
        .listStyle(SidebarListStyle())
        .frame(maxWidth: 900, maxHeight: 600)
        .onAppear {
            //            self.readCodes()
        }
        
    }

    func expandArray() {
        noteController.dummyArray.append(Note(headerCode: "1", headerText: "Section 1", code: "code 101", title: "First Title", bodyText: "description"))
        print("new dummyarray is: ", dump(noteController.dummyArray))
    }
    
}





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
//            //            self.readCodes()
//        }
//    }
//
//    func readCodes() {
//        dummyNotes = Bundle.main.decode([Note].self, from: "httpcodes.json")
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(noteController: NoteModelController())
    }
}

struct SectionHeaderView: View {
    @Binding var section: Note
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
    @Binding var status: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(status.title)
            //                .frame(width: 100)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(status.bodyText)
                .truncationMode(.tail)
            
            Spacer()
            
        }.multilineTextAlignment(.leading)
    }
}

