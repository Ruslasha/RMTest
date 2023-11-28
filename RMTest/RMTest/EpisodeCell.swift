//
//  EpisodeCell.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import Foundation
import UIKit

final class EpisodeCell: UICollectionViewCell {
//    private let characterImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let air_dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private let circleView: UIView = {
//            let circleView = UIView()
//            circleView.layer.cornerRadius = 8
//            circleView.clipsToBounds = true
//            circleView.translatesAutoresizingMaskIntoConstraints = false
//            return circleView
//    }()
    
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(air_dateLabel)
        contentView.addSubview(episodeLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            air_dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            air_dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            air_dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            episodeLabel.topAnchor.constraint(equalTo: air_dateLabel.bottomAnchor, constant: 4),
            episodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            episodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
        ])
        
    }
    
    private func setupCellAppearance() {
        let color = createColor(red: 66, green: 66, blue: 66)
        layer.backgroundColor = color.cgColor
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }

    private func createColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    func configure(with episode: Episode) {
        nameLabel.text = episode.name
//        if character.status == "Alive" {
//            circleView.backgroundColor = .green
//        } else {
//            circleView.backgroundColor = .red
//        }
        air_dateLabel.text = " \(episode.air_date)"
        episodeLabel.text = "\(episode.episode)"
        
//        if let url = URL(string: character.image) {
//            DispatchQueue.global().async {
//                do {
//                    let data = try Data(contentsOf: url)
//                    DispatchQueue.main.async {
//                        self.characterImageView.image = UIImage(data: data)
//                    }
//                } catch {
//                    print("Ошибка загрузки данных: \(error)")
//                }
//            }
//        }

    }
}
