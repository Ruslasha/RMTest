//
//  Character.swift
//  ios-homework
//
//  Created by Руслан Абрамов on 23.11.2023.
//

import Foundation

struct Character: Decodable {
    
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let image: String
    let gender: Gender
    let origin, location: Location
    let episode: [String]
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

struct Location: Codable {
    let name: String
    let url: String
}

struct Results: Decodable {
    let characters: [Character]
    
    private enum CodingKeys: String, CodingKey {
        case characters = "results"
    }
}
