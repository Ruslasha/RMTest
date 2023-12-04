//
//  FavouritesViewController.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import UIKit

class FavouritesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return episodes.count
        return cellCount

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellDef = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
//        guard let cell = selectedCell else { return cellDef }
        let cell = favouritesEpisodes[indexPath.row]
        return cell
    }
    
    private func showCharacterDetails(_ episode: Episode) {

        let detailViewController = CharacterDetailViewController(episode: episode)
            let navController = UINavigationController(rootViewController: detailViewController)
            
            let backButton = UIBarButtonItem(title: "\u{2190} GO BACK", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
            detailViewController.navigationItem.leftBarButtonItem = backButton
        let image = UIImage(named: "logoBlack")
        

        // Создайте UIBarButtonItem с вашей картинкой
        let imageButton = UIBarButtonItem(image: image, style: .plain, target: self, action: .none)
        imageButton.tintColor = .black
        // Установите кнопку на navigationItem в качестве правой кнопки
        detailViewController.navigationItem.rightBarButtonItem = imageButton

 
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: false, completion: nil)

    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: false, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        let height: CGFloat = 400
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodes = episodes[indexPath.item]
        showCharacterDetails(episodes)

    }

    let searchSeriesField: UITextField = {
        let searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.borderStyle = .roundedRect
        searchField.placeholder = "Номер серии"
        return searchField
    }()
            
    var collectionView: UICollectionView!
    var episodes: [Episode] = []
    var favouritesEpisodes: [UICollectionViewCell] = []
    var filteredEpisodes: [Episode] = []
    var selectedField: String?
    let searchFields = ["Номер серии", "Имя персонажа", "Локация"]
    
    func filterEpisodes(with searchText: String, selectedField: String?) {
        if let selectedField = selectedField {
            if searchText.isEmpty {
                filteredEpisodes = episodes
            } else {
                filteredEpisodes = episodes.filter { episode in
                    switch selectedField {
                    case "Номер серии":
                        return episode.episode.contains(searchText)
                    case "Имя персонажа":
                        return episode.episode.contains(searchText)
                    case "Локация":
                        return episode.episode.contains(searchText)
                    default:
                        return false
                    }
                }
            }
            self.selectedField = selectedField
        } else {
            if searchText.isEmpty {
                filteredEpisodes = episodes
            } else {
                filteredEpisodes = episodes.filter { $0.episode.contains(searchText) }
            }
            self.selectedField = nil
        }
        
        collectionView.reloadData()
    }



    
    @objc func searchFieldTextChanged(_ textField: UITextField) {
        if let searchText = textField.text {
            filterEpisodes(with: searchText, selectedField: selectedField)
        }
    }

    @objc func openBottomSheet() {
        let alertController = UIAlertController(title: "Выберите поле", message: nil, preferredStyle: .actionSheet)
        
        for field in searchFields {
            let action = UIAlertAction(title: field, style: .default) { [weak self] _ in
                self?.filterEpisodes(with: self?.searchSeriesField.text ?? "", selectedField: field)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }


    var selectedCell: UICollectionViewCell?
    var cellCount = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Добавляем выбранную ячейку во второй UICollectionView
        if let selectedCell = selectedCell {
            favouritesEpisodes.append(selectedCell)
            cellCount = cellCount + 1
            collectionView.reloadData()
        }
        selectedCell = nil
        collectionView.reloadData()

    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favourites"
        let color = createColor(red: 220, green: 220, blue: 220)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.bounds.width - 20, height: 200) //
        
//        cellCount = 0
        view.backgroundColor = .white
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: "EpisodeCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                ])
        
        
//        NetworkServices.shared.getEpisodes { episodes in
//                    self.episodes = episodes
//                    DispatchQueue.main.async {
//                        self.searchFieldTextChanged(self.searchSeriesField)
//                    }
//                }
//        filterEpisodes(with: "", selectedField: nil)

    }
    
    private func createColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}





       

