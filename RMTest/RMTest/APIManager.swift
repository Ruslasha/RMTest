//
//  APIManager.swift
//  ios-homework
//
//  Created by Руслан Абрамов on 23.11.2023.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    private let baseURL = "https://rickandmortyapi.com/api/character"
    
    func getCharacters(completion: @escaping ([Character]) -> Void) {
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
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(results.characters)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
}

