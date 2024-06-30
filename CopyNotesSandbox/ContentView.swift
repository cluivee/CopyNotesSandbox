//
//  ContentView.swift
//  CopyNotesSandbox
//
//  Created by Clive on 29/06/2024.
//


import SwiftUI


struct ContentView: View {
    @State private var httpSections: [HttpSection] = [
        HttpSection(headerCode: "1", headerText: "Section 1", statuses: [HttpStatus(code: "code 101", title: "First Title", bodyText: "description")]),
        HttpSection(headerCode: "2", headerText: "Section 2", statuses: [HttpStatus(code: "code 202", title: "Title", bodyText: "description")]),
        HttpSection(headerCode: "3", headerText: "Section 3", statuses: [HttpStatus(code: "code 303", title: "Title", bodyText: "description")])
    ]
    
    @State private var showSamplesSheet = false
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(httpSections) { section in
                    Section(header: SectionHeaderView(section: section)) {
                        ForEach(section.statuses) { status in
                            NavigationLink(destination: DetailView(httpStatus: status)) {
                                TableRowView(status: status)
                            }
                        }
                    }
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
    
    // This is where the httpSections are downloaded I believe
    func readCodes() {
        httpSections = Bundle.main.decode([HttpSection].self, from: "httpcodes.json")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SectionHeaderView: View {
    let section: HttpSection
    
    var body: some View {
        HStack(spacing: 20) {
            Text(section.headerCode)
                .layoutPriority(1)
            
            Text(section.headerText)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
            
        }
    }
}

struct TableRowView: View {
    let status: HttpStatus
    
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




//
//struct ContentView: View {
//    @State private var httpSections: [HttpSection] = []
//    @State private var showSamplesSheet = false
//
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(httpSections) { section in
//                     Section(header: SectionHeaderView(section: section)) {
//                         ForEach(section.statuses) { status in
//                            NavigationLink(destination: DetailView(httpStatus: status)) {
//                                 TableRowView(status: status)
//                             }
//                         }
//                     }
//                 }
//            }
//            .frame(minWidth: 250, maxWidth: 350)
//        }
//        .listStyle(SidebarListStyle())
//        .frame(maxWidth: 900, maxHeight: 600)
//        .onAppear {
//            self.readCodes()
//        }
//    }
//
//    func readCodes() {
//        httpSections = Bundle.main.decode([HttpSection].self, from: "httpcodes.json")
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//struct SectionHeaderView: View {
//    let section: HttpSection
//
//    var body: some View {
//        HStack(spacing: 20) {
//            Text(section.headerCode)
//                .layoutPriority(1)
//
//            Text(section.headerText)
//                .lineLimit(1)
//                .truncationMode(.tail)
//
//            Spacer()
//
//        }
//    }
//}
//
//struct TableRowView: View {
//    let status: HttpStatus
//
//    var body: some View {
//        HStack(spacing: 20) {
//            Text(status.code)
//                .frame(width: 40)
//                .font(.headline)
//                .foregroundColor(.secondary)
//
//            Text(status.title)
//                .truncationMode(.tail)
//
//            Spacer()
//        }
//    }
//}
