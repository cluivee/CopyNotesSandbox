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
   
    var body: some View {
         VStack {
             
            Text("Index Position: \(noteSection.nr)")
                .font(.headline)
                .padding()
             Text(noteSection.title)
                .font(.title)
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
        //Placing the toolbar here because putting it on the navigationView causes the plus button to dissappear - We've finally found out that the spacer in this detailView was messing up the spacer in the sidebar
        .toolbar {
            ToolbarItemGroup{
                Button("Edit") {}
                Button("Save") {}
                Button("Copy") {}
                // Ok So apparently this was messing up the spacer in the sidebar
//                Spacer().frame(width: 50)
                Button("Delete") {}
            }
        }
        
    
    }
}
    

struct DetailView_Previews: PreviewProvider {
    // some variable used just for the preview, has nothing to do with the actual data
    @State static var previewNote: Note = Note(nr: 1, headerCode: "3", headerText: "Section 1", title: "Changed Title", bodyText: "description")
    static var previews: some View {
    
        DetailView(noteSection: $previewNote)
    }
}
