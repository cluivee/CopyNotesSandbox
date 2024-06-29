//
//  ContentView.swift
//  CopyNotesSandbox
//
//  Created by Clive on 29/06/2024.
//
import SwiftUI

struct ContentView: View {
    @State private var httpSections: [HttpSection] = []
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
            self.readCodes()
        }
    }
    
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
        HStack(spacing: 20) {
            Text(status.code)
                .frame(width: 40)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(status.title)
                .truncationMode(.tail)
            
            Spacer()
        }
    }
}
