//
//  CharacterDetailViewController.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import Foundation
import UIKit
import Photos

final class CharacterDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        let labelTop = UILabel(frame: CGRect(x: 0, y: CGFloat(0) * labelHeight, width: labelWidth, height: labelHeight))
        labelTop.font = UIFont.boldSystemFont(ofSize: 16)
        labelTop.text = labels[indexPath.row * 2]
        cell.contentView.addSubview(labelTop)
        
        let labelBottom = UILabel(frame: CGRect(x: 0, y: CGFloat(1) * labelHeight, width: labelWidth, height: labelHeight))
        labelBottom.font = UIFont.systemFont(ofSize: 14)
        labelBottom.text = labels[indexPath.row * 2 + 1]
        cell.contentView.addSubview(labelBottom)

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Выбрана ячейка \(indexPath.row + 1)")
    }
    
    private var tableView: UITableView = {
        var table = UITableView()
        return table
    }()
    
    private let episode: Episode
    
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
        return logoButton
    }()
    
    @objc private func logoButtonTapped() {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { (_) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                } else {
                }

            }
            alertController.addAction(takePhotoAction)
            
            let chooseFromGalleryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { (_) in
                self.checkPhotoLibraryAuthorization()
            }
            alertController.addAction(chooseFromGalleryAction)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = logoIconButton
                popoverController.sourceRect = logoIconButton.bounds
            }
            present(alertController, animated: true, completion: nil)

    }
    
    @objc func chooseFromGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func checkPhotoLibraryAuthorization() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == .authorized {
                    DispatchQueue.main.async {
                        self.chooseFromGallery()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert()
                    }
                }
            }
            
        case .authorized:
            chooseFromGallery()
            
        case .denied, .restricted:
            showSettingsAlert()
            
        case .limited:
            break
        @unknown default:
            break
        }
    }

    func showSettingsAlert() {
        let alertController = UIAlertController(title: "Доступ к фотографиям отклонен", message: "Для использования фотографий необходимо разрешить доступ в настройках телефона.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    private let networkServices = NetworkServices()
    
    init(episode: Episode) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        loadData()
        prepareTableView()
    }
    
    private func prepareTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        logoIconButton.addTarget(self, action: #selector(logoButtonTapped), for: .touchUpInside)
        tableView.reloadData()
    }
    
    private func prepareView() {
        
        view.backgroundColor = .white
        addSubview()
        setupConstraint()
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
                    self?.updateDataCharacter(with: characterDetails)
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
            logoIconButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            logoIconButton.widthAnchor.constraint(equalToConstant: 30),
            logoIconButton.heightAnchor.constraint(equalToConstant: 30),

        ])
    }
    
    private var genderCharacter = ""
    private var statusCharacter = ""
    private var specieCharacter = ""
    private var originCharacter = ""
    private var typeCharacter = ""
    private var locationCharacter = ""
    private func updateDataCharacter(with characterDetails: Character) {
        nameLabel.text = characterDetails.name
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
        
        if URL(string: characterDetails.image) != nil {
            if let url = URL(string: characterDetails.image) {
                networkServices.loadImage(url: url, in: self.characterImageView)
            }
        }
        tableView.reloadData()
    }
}

extension CharacterDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            characterImageView.image = pickedImage
        }
        if let image = info[.originalImage] as? UIImage {
            characterImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

