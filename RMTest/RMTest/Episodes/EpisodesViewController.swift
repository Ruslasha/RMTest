//
//  EpisodesViewController.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import UIKit

class EpisodesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return episodes.count
        return filteredEpisodes.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        
//        let episode = episodes[indexPath.item]
        let episode = filteredEpisodes[indexPath.row]
        cell.configure(with: episode)
        
        return cell
    }
    
    private func showCharacterDetails(_ episode: Episode) {

        let detailViewController = CharacterDetailViewController(episode: episode)
            let navController = UINavigationController(rootViewController: detailViewController)
            
            let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
            detailViewController.navigationItem.leftBarButtonItem = backButton
 
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
    var filteredEpisodes: [Episode] = []
    
    func filterEpisodes(with searchText: String) {
        if searchText.isEmpty {
            filteredEpisodes = episodes
        } else {
            filteredEpisodes = episodes.filter { $0.episode.contains(searchText) }
        }
        collectionView.reloadData()
    }
    
    @objc func searchFieldTextChanged(_ textField: UITextField) {
        if let searchText = textField.text {
            filterEpisodes(with: searchText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(searchSeriesField)
        searchSeriesField.addTarget(self, action: #selector(searchFieldTextChanged(_:)), for: .editingChanged)

        NSLayoutConstraint.activate([
            searchSeriesField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchSeriesField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchSeriesField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchSeriesField.heightAnchor.constraint(equalToConstant: 50)
                ])
        
        title = "Episodes"
        let color = createColor(red: 220, green: 220, blue: 220)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.bounds.width - 20, height: 200) //
        
        view.backgroundColor = color
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: "EpisodeCell")
        collectionView.backgroundColor = color
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchSeriesField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                ])
        
        
        NetworkServices.shared.getEpisodes { episodes in
                    self.episodes = episodes
                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
                        self.searchFieldTextChanged(self.searchSeriesField)
                    }
                }
        
    }
    
    private func createColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//        filterEpisodesByNumber(searchController.searchBar.text)
//    }
//
//    func filterEpisodesByNumber(_ searchText: String?) {
//        guard let searchText = searchText, !searchText.isEmpty else {
//               // Если текст поиска пустой, отобразить все серии
//            self.collectionView.reloadData()
//               return
//           }
//           
//           let episodeNumber = Int(searchText) ?? 0
////           let filteredEpisodes = episodes.filter { $0.number == episodeNumber }
//        self.collectionView.reloadData()
//
//    }


    
}
//extension EpisodesViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        filterEpisodesByNumber(searchController.searchBar.text)
//    }
//}




       
