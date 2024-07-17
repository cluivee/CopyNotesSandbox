//
//  DetailView.swift
//  SwiftUI_Mac_BigSur_Clive_Tutorial
//
//  Created by Clive on 19/06/2024.
//

import SwiftUI

struct DetailView: View {
    @Binding var noteSection: Note

    var body: some View {
         VStack {
            Text("Index Position: \(noteSection.nr)")
                .font(.headline)
                .padding()
             Text(noteSection.title)
                .font(.title)
             TextField("dummy", text: $noteSection.title).labelsHidden()
             TextEditor(text: $noteSection.bodyText)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //Placing the toolbar here because putting it on the navigationView causes the plus button to dissappear

        .toolbar {
            ToolbarItemGroup{
                Button("Edit") {}
                Button("Save") {}
                Button("Copy") {}
                Spacer().frame(width: 50)
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
