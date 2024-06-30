//
//  DetailView.swift
//  SwiftUI_Mac_BigSur_Clive_Tutorial
//
//  Created by Clive on 19/06/2024.
//

import SwiftUI

struct DetailView: View {
    let httpStatus: HttpStatus
    @State private var catImage: NSImage?

    var body: some View {
         VStack {
            Text("HTTP Status Code: \(httpStatus.code)")
                .font(.headline)
                .padding()
            Text(httpStatus.title)
                .font(.title)
            
            if catImage != nil {
                Image(nsImage: catImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
    func getCatImage() {
        let url = httpStatus.imageUrl
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                DispatchQueue.main.async {
                    self.catImage = NSImage(data: data)
                }
            }
        }
        task.resume()
    }

}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(httpStatus: HttpStatus(code: "404", title: "Not Found"))
    }
}
