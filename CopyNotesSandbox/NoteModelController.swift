//
//  HttpStatus.swift
//  CopyNotesSandbox
//
//  Created by Clive on 29/06/2024.
//

import Foundation
import SwiftUI

class NoteModelController: ObservableObject {
    @Published var note: Note = Note(nr: 1, headerCode: "3", headerText: "Section 1", title: "Changed Title", bodyText: "description")
    
    // so its probably possible to make user an array, and then just add an extra step in the next view to extract the data from the array, and keep everything else the same. I will try adding another dummy array to test though
    
    @Published var dummyArray = [Note(nr: 1, headerCode: "1", headerText: "Section 1", title: "First Title", bodyText: "description"),
                                 Note(nr: 2, headerCode: "2", headerText: "Section 1", title: "Second Title", bodyText: "second description"),
                                 Note(nr: 3, headerCode: "3", headerText: "Section 1", title: "Third Title", bodyText: "third description"),    ]
    
}

struct Note: Identifiable, Decodable, Hashable {
    let id = UUID()
    var nr: Int
    var headerCode: String
    let headerText: String
    
    var title: String
    var bodyText: String
    
    

    
    static func load() -> Note {
          // Here you would implement the logic to load a User.
          // For demonstration, we'll just return a dummy user.
        return Note(nr: 1, headerCode: "3", headerText: "Section 1", title: "First Title", bodyText: "description")      }
    

}


//struct HttpStatus: Identifiable, Decodable {
//    let id = UUID()
//    var code: String
//    var title: String = "Title"
//    var bodyText: String = "Body Text"
//
//    var imageUrl: URL {
//        let address = "https://http.cat/\(code).jpg"
//        return URL(string: address)!
//    }

//    enum CodingKeys: String, CodingKey {
//        case code
//        case title
//    }
//}
