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
    var characters: [String]
//    var characterDetail: Character
}

//struct EpisodeDetail {
//    
//    let id: Int
//    let name: String
//    let air_date: String
//    let episode: String
////    let image: String
//    var characters: [String]
//    var characterDetail: Character
//}

struct EpisodeResults: Decodable {
    var episodes: [Episode]
//    var characterDetail: Character
//   let airDate: String
    
    private enum CodingKeys: String, CodingKey {
        case episodes = "results"
//        case airDate = "air_date"
    }
}

