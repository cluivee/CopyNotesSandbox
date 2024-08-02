//
//  DetailView.swift
//  SwiftUI_Mac_BigSur_Clive_Tutorial
//
//  Created by Clive on 19/06/2024.
//

import SwiftUI

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear //<<here clear
            drawsBackground = true
        }
        
    }
}

struct DetailView: View {
    @Binding var noteSection: Note
    @StateObject var noteController: NoteModelController
    var function: () -> Void
    
    
    var body: some View {
        VStack {
            //
            //            Text("Index Position: \(noteSection.nr)")
            //                .font(.headline)
            //                .padding()
            //             Text(noteSection.title)
            //                .font(.title)
            TextField("Title", text: $noteSection.title).labelsHidden()
                .font(.title.bold())
                .border(.clear)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.top, .leading], 4)
            //             TextEditor(text: $noteSection.bodyText)
            TextEditorView(string: $noteSection.bodyText)
                .font(.title3)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(EdgeInsets(top: 20, leading: 50, bottom: 20, trailing: 50))
        //Placing the toolbar here because putting it on the navigationView causes the plus button to dissappear - We've finally found out that the spacer in this detailView was messing up the spacer in the sidebar
        .toolbar {
            ToolbarItemGroup{
                Button("Edit") {}
                Button("Save") {}
                Button("Copy") {copyToClipboard(bodyText: noteSection.bodyText)}
                // Ok So apparently this was messing up the spacer in the sidebar
                //                Spacer().frame(width: 50)
                Button("Delete") {function()}
            }
        }
        
    }
    
    private func copyToClipboard(bodyText: String) {
        if noteSection.bodyText != nil {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(bodyText, forType: .string)
        } else {
            print("selected Index is nil" )
        }
    }
    
//    private func deleteSelectedNote() {
//        if let index = noteController.dummyArray.firstIndex(where: { $0.id == noteSection.id }) {
//            noteController.dummyArray.remove(at: index)
//            if noteController.dummyArray.isEmpty {
//                // If all notes are deleted, you may need to handle the case where no note is selected
//
//            } else {
//                noteSection = noteController.dummyArray[max(0, index - 1)]
//            }
//            // Renumber the remaining notes
//            for i in 0..<noteController.dummyArray.count {
//                noteController.dummyArray[i].nr = i + 1
//            }
//        }
//    }
    
    
}


struct DetailView_Previews: PreviewProvider {
    // some variable used just for the preview, has nothing to do with the actual data
    @State static var previewNote: Note = Note(nr: 1, headerCode: "3", headerText: "Section 1", title: "Changed Title", bodyText: "description")
    
    static var previews: some View {
        
        Group {
            DetailView(noteSection: $previewNote, noteController: NoteModelController(), function: {})
        }
    }
}
