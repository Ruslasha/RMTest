//
//  NetworkServices.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import Foundation

final class NetworkServices {
    static let shared = NetworkServices()
    private let baseURL = "https://rickandmortyapi.com/api/episode"
    
    func getEpisodes(completion: @escaping ([Episode]) -> Void) {
        guard let url = URL(string: baseURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let results = try JSONDecoder().decode(EpisodeResults.self, from: data)
                completion(results.episodes)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
}
