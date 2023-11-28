//
//  CharacterDetailViewController.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import Foundation
import UIKit

final class CharacterDetailViewController: UIViewController {
    
    private let episode: Episode
    
//    private let character: Character
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let speciesGenderTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let speciesGenderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let originLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let originLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let episodesTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let linkSkrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let linkContentView: UIView = {
        let linkContentView = UIView()
        linkContentView.translatesAutoresizingMaskIntoConstraints = false
        return linkContentView
    }()
    
    private let circleView: UIView = {
        let circleView = UIView()
        circleView.layer.cornerRadius = 8
        circleView.clipsToBounds = true
        circleView.translatesAutoresizingMaskIntoConstraints = false
        return circleView
    }()
    
    private let networkServices = NetworkServices()
    
    
    init(episode: Episode) {
        self.episode = episode
//        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        prepareView()
        loadData()
    }
    
    private func prepareView() {
//        let color = createColor(red: 34, green: 39, blue: 45)
        view.backgroundColor = .white
        addSubview()
        setupConstraint()
    }
    
    private func createColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    private func addSubview() {
        view.addSubview(characterImageView)
        view.addSubview(nameLabel)
        view.addSubview(idLabel)
        view.addSubview(statusTitleLabel)
        view.addSubview(statusLabel)
        view.addSubview(speciesGenderTitleLabel)
        view.addSubview(speciesGenderLabel)
        view.addSubview(originLocationTitleLabel)
        view.addSubview(originLocationLabel)
        view.addSubview(episodesTitleLabel)
        view.addSubview(episodesLabel)
        view.addSubview(linkSkrollView)
        view.addSubview(linkContentView)
        view.addSubview(circleView)
    }
    
    private func loadData() {
        networkServices.loadCharacterData(for: episode.characters[0]) { [weak self] result in
            switch result {
            case .success(let characterDetails):
                DispatchQueue.main.async {
                    self?.updateUI(with: characterDetails)
                }
            case .failure(let error):
                print("Error loading data: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 200),
            characterImageView.heightAnchor.constraint(equalToConstant: 200),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            statusTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            statusTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            circleView.topAnchor.constraint(equalTo: statusTitleLabel.bottomAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 16),
            circleView.heightAnchor.constraint(equalToConstant: 16),
            
            statusLabel.topAnchor.constraint(equalTo: statusTitleLabel.bottomAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 8),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            speciesGenderTitleLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            speciesGenderTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            speciesGenderTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            speciesGenderLabel.topAnchor.constraint(equalTo: speciesGenderTitleLabel.bottomAnchor),
            speciesGenderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            speciesGenderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            originLocationTitleLabel.topAnchor.constraint(equalTo: speciesGenderLabel.bottomAnchor, constant: 8),
            originLocationTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            originLocationTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            originLocationLabel.topAnchor.constraint(equalTo: originLocationTitleLabel.bottomAnchor),
            originLocationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            originLocationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            episodesTitleLabel.topAnchor.constraint(equalTo: originLocationLabel.bottomAnchor, constant: 8),
            episodesTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            episodesTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            episodesLabel.topAnchor.constraint(equalTo: episodesTitleLabel.bottomAnchor),
            episodesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            episodesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            linkSkrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            linkSkrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            linkSkrollView.topAnchor.constraint(equalTo: episodesTitleLabel.bottomAnchor),
            linkSkrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            linkContentView.leadingAnchor.constraint(equalTo: linkSkrollView.leadingAnchor),
            linkContentView.trailingAnchor.constraint(equalTo: linkSkrollView.trailingAnchor),
            linkContentView.topAnchor.constraint(equalTo: linkSkrollView.topAnchor),
            linkContentView.widthAnchor.constraint(equalTo: linkSkrollView.widthAnchor),
        ])
    }
    
    @objc func linkTapped(_ sender: UIButton) {
        guard let linkTitle = sender.title(for: .normal) else { return }
        
        let alert = UIAlertController(title: "Ссылка", message: "\(linkTitle) нажата", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func createLink() {
        var links: [UIButton] = []
        
//        for string in character.episode {
//            let linkButton = UIButton()
//            linkButton.setTitle(string, for: .normal)
//            linkButton.addTarget(self, action: #selector(linkTapped(_:)), for: .touchUpInside)
//            
//            links.append(linkButton)
//        }
        
        for (index, linkButton) in links.enumerated() {
            linkButton.translatesAutoresizingMaskIntoConstraints = false
            linkContentView.addSubview(linkButton)
            
            NSLayoutConstraint.activate([
                linkButton.topAnchor.constraint(equalTo: linkContentView.topAnchor, constant: CGFloat(index * 40 + 20)),
                linkButton.centerXAnchor.constraint(equalTo: linkContentView.centerXAnchor)
            ])
        }
        linkSkrollView.contentSize = linkContentView.bounds.size
    }
    
    private func updateUI(with characterDetails: Character) {
        nameLabel.text = characterDetails.name
        statusTitleLabel.text = "Live status:"
        if characterDetails.status == "Alive" {
            circleView.backgroundColor = .green
        } else {
            circleView.backgroundColor = .red
        }
        statusLabel.text = " \(characterDetails.status)"
        speciesGenderTitleLabel.text = "Species and gender: "
        speciesGenderLabel.text = "\(characterDetails.species) (\(characterDetails.gender))"
        originLocationTitleLabel.text = "Last known location:"
        originLocationLabel.text = "\(characterDetails.location.name)"
        episodesTitleLabel.text = "Episodes: "
        
        if URL(string: characterDetails.image) != nil {
            if let url = URL(string: characterDetails.image) {
                networkServices.loadImage(url: url, in: self.characterImageView)
            }
             }
    }
}
