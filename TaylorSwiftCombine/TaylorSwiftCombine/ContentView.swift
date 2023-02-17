//
//  ContentView.swift
//  TaylorSwiftCombine
//
//  Created by Jerrick Warren on 9/15/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
  
    var body: some View {
        List(viewModel.results) { album in
            HStack {
                Text(album.trackName)
                Spacer()
            
                AsyncImage(url: URL(string: album.artworkUrl100)) { phase in
                    switch phase {
                    case .empty:
                        // Show placeholder view
                        ProgressView()
                    case .success(let image):
                            image.resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    case .failure(let error):
                        
                       let _ = print("\(error.localizedDescription)")
                        // Show error view
                        Image(systemName: "photo")
                      
                    @unknown default:
                        fatalError()
                    }
                }
                
            }
        }.onAppear {
            viewModel.loadFeed()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
