//
//  FavouritesArray.swift
//  RMTest
//
//  Created by Руслан Абрамов on 04.12.2023.
//

import Foundation

class FavouritesArray {
    static let shared = FavouritesArray()

    var favouritesEpisodeArray: [Episode] = []
    private init() {
        
    }
    
    func append(element: Episode) {
        favouritesEpisodeArray.append(element)
    }

}
