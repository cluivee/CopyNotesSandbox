//
//  HttpStatus.swift
//  CopyNotesSandbox
//
//  Created by Clive on 29/06/2024.
//

import Foundation
import SwiftUI


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

class NoteModelController: ObservableObject {
    @Published var note: Note = Note(headerCode: "3", headerText: "Section 1", code: "code 202", title: "Changed Title", bodyText: "description")
    
    // so its probably possible to make user an array, and then just add an extra step in the next view to extract the data from the array, and keep everything else the same. I will try adding another dummy array to test though
    
    @Published var dummyArray = [Note(headerCode: "1", headerText: "Section 1", code: "code 101", title: "First Title", bodyText: "description"),
                      Note(headerCode: "2", headerText: "Section 1", code: "code 101", title: "Second Title", bodyText: "second description"),
                      Note(headerCode: "3", headerText: "Section 1", code: "code 101", title: "Third Title", bodyText: "third description"),    ]
    
}

struct Note: Identifiable, Decodable {
    let id = UUID()
    let headerCode: String
    let headerText: String
    //    let statuses: [HttpStatus]
    var code: String
    var title: String
    var bodyText: String
    
    
    static func load() -> Note {
          // Here you would implement the logic to load a User.
          // For demonstration, we'll just return a dummy user.
          return Note(headerCode: "3", headerText: "Section 1", code: "code 101", title: "First Title", bodyText: "description")      }
    

}
