//
//  Model.swift
//  TaylorSwiftCombine
//
//  Created by Jerrick Warren on 9/15/22.
//

import Foundation
import Combine

struct Response: Codable {
    var results: [Music]
}

class Music: Codable, Identifiable {
    
    var id: UUID
    var trackId: Int
    var trackName: String
    var collectionName: String
    var artworkUrl100: String
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.trackId = try container.decodeIfPresent(Int.self, forKey: .trackId) ?? 1
        self.trackName = try container.decodeIfPresent(String.self, forKey: .trackName) ?? ""
        self.collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName) ?? ""
        self.artworkUrl100 = try container.decodeIfPresent(String.self, forKey: .artworkUrl100) ?? ""
    }
    
}
