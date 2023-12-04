//
//  EpisodeCell.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import Foundation
import UIKit

final class EpisodeCell: UICollectionViewCell {
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let monitorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let air_dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameEpisodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let randomCharacterLinkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let heartButton: UIButton = {
        let heart = HeartButton()
        heart.translatesAutoresizingMaskIntoConstraints = false
        return heart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCellAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupCellAppearance()
    }
    
    private func setupViews() {
        addSubview()
        setupConstraint()
    }
    
    private func addSubview() {
        contentView.addSubview(nameEpisodeLabel)
        contentView.addSubview(monitorImageView)
        contentView.addSubview(randomCharacterLinkLabel)
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameCharacterLabel)
        contentView.addSubview(heartButton)
        
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 400),
            characterImageView.heightAnchor.constraint(equalToConstant: 300),
            
            nameCharacterLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 8),
            nameCharacterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameCharacterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            monitorImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            monitorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            monitorImageView.widthAnchor.constraint(equalToConstant: 30),
            monitorImageView.heightAnchor.constraint(equalToConstant: 30),
            
            nameEpisodeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            nameEpisodeLabel.leadingAnchor.constraint(equalTo: monitorImageView.trailingAnchor, constant: 10),
            nameEpisodeLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -5),
            
            heartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            heartButton.widthAnchor.constraint(equalToConstant: 50),
            heartButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }
    
    private func setupCellAppearance() {
        let color = createColor(red: 255, green: 255, blue: 255)
        layer.backgroundColor = color.cgColor
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }

    private func createColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    func configure(with episode: Episode) {
        
        monitorImageView.image = UIImage(named: "MonitorPlay")
        nameEpisodeLabel.text = "\(episode.name)" + " | " + "\(episode.episode)"
        if let randomCharacter = getRandomElement(from: episode.characters) {
            
            let networkServices = NetworkServices()
            
            networkServices.loadCharacterData(for: randomCharacter) { [weak self] result in
                switch result {
                case .success(let characterDetails):
                    DispatchQueue.main.async {
                        self?.nameCharacterLabel.text = "\(characterDetails.name)"
                        if let url = URL(string: characterDetails.image) {
                            networkServices.loadImage(url: url, in: self!.characterImageView)
                        }
                    }
                case .failure(let error):
                    print("Error loading data: \(error.localizedDescription)")
                }
            }
        } else {
            randomCharacterLinkLabel.text = ""
        }
    }

    
    func getRandomElement<T>(from array: [T]) -> T? {
        guard !array.isEmpty else {
            return nil
        }
        
        let randomIndex = Int.random(in: 0..<array.count)
        return array[randomIndex]
    }

}
