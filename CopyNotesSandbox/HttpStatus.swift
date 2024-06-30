//
//  HttpStatus.swift
//  CopyNotesSandbox
//
//  Created by Clive on 29/06/2024.
//

import Foundation


struct HttpStatus: Identifiable, Decodable {
    let id = UUID()
    var code: String
    var title: String = "Title"
    var bodyText: String = "Body Text"
    
    var imageUrl: URL {
        let address = "https://http.cat/\(code).jpg"
        return URL(string: address)!
    }

//    enum CodingKeys: String, CodingKey {
//        case code
//        case title
//    }
}

struct HttpSection: Identifiable, Decodable {
    let id = UUID()
    let headerCode: String
    let headerText: String
    let statuses: [HttpStatus]

//    enum CodingKeys: String, CodingKey {
//        case headerCode
//        case headerText
//        case statuses
//    }
}
