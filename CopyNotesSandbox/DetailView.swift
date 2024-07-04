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
            Text("HTTP Status Code: \(noteSection.code)")
                .font(.headline)
                .padding()
             Text(noteSection.title)
                .font(.title)
             TextEditor(text: $noteSection.bodyText)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    
    }
}
    

struct DetailView_Previews: PreviewProvider {
    // some variable used just for the preview, has nothing to do with the actual data
    @State static var previewNote: Note = Note(headerCode: "3", headerText: "Section 1", code: "code 202", title: "Changed Title", bodyText: "description")
    static var previews: some View {
    
        DetailView(noteSection: $previewNote)
    }
}
