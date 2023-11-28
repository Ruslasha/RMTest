//
//  Episode.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import Foundation

struct Episode: Decodable {
    
    let id: Int
    let name: String
    let air_date: String
    let episode: String
//    let image: String
    let character: [String]
}


struct EpisodeResults: Decodable {
    let episodes: [Episode]
    
    private enum CodingKeys: String, CodingKey {
        case episodes = "results"
    }
}
