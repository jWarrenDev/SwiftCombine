//
//  ContentView.swift
//  TaylorSwiftCombine
//
//  Created by Jerrick Warren on 9/15/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var apiService = APIService()
    
    init() {
        let _ = self.apiService.loadFeed();
    }

    var body: some View {
        List(apiService.response) { album in
            HStack {
                Text(album.trackName)
                Spacer()
                ImageView(url: album.artworkUrl100)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
