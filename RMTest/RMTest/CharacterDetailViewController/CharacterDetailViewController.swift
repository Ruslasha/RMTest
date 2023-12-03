//
//  CharacterDetailViewController.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import Foundation
import UIKit

final class CharacterDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Создание и настройка ячейки таблицы
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let labelWidth = cell.contentView.frame.width
        let labelHeight = cell.contentView.frame.height / 2
        
        let labels = [
            "Gender",
            genderCharacter,
            "Status",
            statusCharacter,
            "Specie",
            specieCharacter,
            "Origin",
            originCharacter,
            "Type",
            typeCharacter,
            "Location",
            locationCharacter
        ]
        
        
        //        for i in 0..<2 {
        let labelTop = UILabel(frame: CGRect(x: 0, y: CGFloat(0) * labelHeight, width: labelWidth, height: labelHeight))
        labelTop.font = UIFont.boldSystemFont(ofSize: 16)
        labelTop.text = labels[indexPath.row * 2]
        cell.contentView.addSubview(labelTop)
        
        let labelBottom = UILabel(frame: CGRect(x: 0, y: CGFloat(1) * labelHeight, width: labelWidth, height: labelHeight))
        labelBottom.font = UIFont.systemFont(ofSize: 14)
        labelBottom.text = labels[indexPath.row * 2 + 1]
        cell.contentView.addSubview(labelBottom)
        //        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Обработка выбора ячейки таблицы
        print("Выбрана ячейка \(indexPath.row + 1)")
    }
    
    //    var tableView: UITableView!
    
    private var tableView: UITableView = {
        var table = UITableView()
        //        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private let episode: Episode
    
    //    private let character: Character
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Informations"
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let logoIconButton: UIButton = {
        let logoButton = UIButton()
        logoButton.translatesAutoresizingMaskIntoConstraints = false
        logoButton.setImage(UIImage(named: "PhotoIcon"), for: .normal)
        logoButton.contentMode = .scaleAspectFit
//        logoButton.addTarget(CharacterDetailViewController.self, action: #selector(logoButtonTapped), for: .touchUpInside)
        return logoButton
    }()
    
    @objc private func logoButtonTapped() {
//        dismiss(animated: false, completion: nil)
    }
    
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
        //        loadData()
        prepareView()
        
        loadData()
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // Настройка делегата и источника данных для таблицы
        tableView.delegate = self
        tableView.dataSource = self
        
        // Добавление UITableView в иерархию представлений
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        logoIconButton.addTarget(CharacterDetailViewController.self, action: #selector(logoButtonTapped), for: .touchUpInside)
        tableView.reloadData()
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
        view.addSubview(infoLabel)
        view.addSubview(logoIconButton)
        
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
            characterImageView.widthAnchor.constraint(equalToConstant: 150),
            characterImageView.heightAnchor.constraint(equalToConstant: 150),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logoIconButton.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 20),
//            logoIconButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            logoIconButton.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10),
            logoIconButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            logoIconButton.widthAnchor.constraint(equalToConstant: 30),
            logoIconButton.heightAnchor.constraint(equalToConstant: 30),

        ])
    }
    
    @objc func linkTapped(_ sender: UIButton) {
        guard let linkTitle = sender.title(for: .normal) else { return }
        
        let alert = UIAlertController(title: "Ссылка", message: "\(linkTitle) нажата", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private var genderCharacter = ""
    private var statusCharacter = ""
    private var specieCharacter = ""
    private var originCharacter = ""
    private var typeCharacter = ""
    private var locationCharacter = ""
    private func updateUI(with characterDetails: Character) {
        nameLabel.text = characterDetails.name
        //        statusTitleLabel.text = "Live status:"
        //        if characterDetails.status == "Alive" {
        //            circleView.backgroundColor = .green
        //        } else {
        //            circleView.backgroundColor = .red
        //        }
        genderCharacter = "\(characterDetails.gender)"
        statusCharacter = "\(characterDetails.status)"
        specieCharacter = "\(characterDetails.species)"
        originCharacter = "\(characterDetails.origin.name)"
        if characterDetails.type == "" {
            typeCharacter = "unknown"
        } else {
            typeCharacter = "\(characterDetails.type)"
        }
       
        locationCharacter = "\(characterDetails.location.name)"
        //        statusLabel.text = " \(characterDetails.status)"
        //        speciesGenderTitleLabel.text = "Species and gender: "
        //        speciesGenderLabel.text = "\(characterDetails.species) (\(characterDetails.gender))"
        //        originLocationTitleLabel.text = "Last known location:"
        //        originLocationLabel.text = "\(characterDetails.location.name)"
        //        episodesTitleLabel.text = "Episodes: "
        
        if URL(string: characterDetails.image) != nil {
            if let url = URL(string: characterDetails.image) {
                networkServices.loadImage(url: url, in: self.characterImageView)
            }
        }
        tableView.reloadData()
    }
}
