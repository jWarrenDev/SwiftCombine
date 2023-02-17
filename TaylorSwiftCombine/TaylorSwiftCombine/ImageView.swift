//
//  ImageView.swift
//  TaylorSwiftCombine
//
//  Created by Jerrick Warren on 9/15/22.
//

import Foundation
import SwiftUI
import Combine

struct ImageView: View {
    let url: String
    @ObservedObject var imageLoader = ImageLoader()
    @State private var image: UIImage = UIImage()
    
    var body: some View {
        
        let url = url
        
         Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:100, height: 100)
            .shadow(radius: 10)
            .onReceive(imageLoader.$image) { image in
                self.image = image
            }
            .onAppear {
                imageLoader.loadImage(for: url)
            }
    }
}

