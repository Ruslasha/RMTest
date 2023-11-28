//
//  NetworkServices.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import Foundation
import UIKit

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
    
    func loadCharacterData(for character: String, completion: @escaping (Result<Character, Error>) -> Void) {
        guard let url = URL(string: "\(character)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let characterDetails = try JSONDecoder().decode(Character.self, from: data)
                completion(.success(characterDetails))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loadImage(url: URL, in imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Проверяем наличие ошибок
            if let error = error {
                print("Ошибка при загрузке картинки: \(error.localizedDescription)")
                return
            }
            
            // Проверяем наличие данных
            guard let data = data else {
                print("Не удалось получить данные картинки")
                return
            }
            
            // Создаем изображение из данных
            guard let image = UIImage(data: data) else {
                print("Не удалось создать изображение из данных")
                return
            }
            
            // Обновляем UI на главной очереди
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
    
}
