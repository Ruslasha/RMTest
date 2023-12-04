//
//  FavouritesArray.swift
//  RMTest
//
//  Created by Руслан Абрамов on 04.12.2023.
//

import Foundation

class FavouritesArray {
    static let shared = FavouritesArray()

    var favouritesArray: [EpisodeCell] = []
    var favouritesEpisodeArray: [Episode] = []

    private init() {
        
    }
    
    func append(element: Episode) {
        favouritesEpisodeArray.append(element)
    }

    func append(element: EpisodeCell) {
        favouritesArray.append(element)
    }

    func getArray() -> [EpisodeCell] {
        return favouritesArray
    }
}
