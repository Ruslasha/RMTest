//
//  CharacterCell.swift
//  ios-homework
//
//  Created by Руслан Абрамов on 23.11.2023.
//

import Foundation
import UIKit

final class CharacterCell: UICollectionViewCell {
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let circleView: UIView = {
            let circleView = UIView()
            circleView.layer.cornerRadius = 8
            circleView.clipsToBounds = true
            circleView.translatesAutoresizingMaskIntoConstraints = false
            return circleView
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
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(circleView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            characterImageView.widthAnchor.constraint(equalTo: characterImageView.heightAnchor),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            circleView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            circleView.widthAnchor.constraint(equalToConstant: 16),
            circleView.heightAnchor.constraint(equalToConstant: 16),
            circleView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 5),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
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
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        if character.status == "Alive" {
            circleView.backgroundColor = .green
        } else {
            circleView.backgroundColor = .red
        }
        statusLabel.text = " \(character.status)"
        locationLabel.text = "\u{1F30E} \(character.location.name)"
        
        if let url = URL(string: character.image) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.characterImageView.image = UIImage(data: data)
                    }
                } catch {
                    print("Ошибка загрузки данных: \(error)")
                }
            }
        }

    }
}
