//
//  EpisodesViewController.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import UIKit

class EpisodesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredEpisodes.count
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            guard let cell = gesture.view as? UICollectionViewCell else { return }
            guard let indexPath = collectionView.indexPath(for: cell) else { return }
            
            filteredEpisodes.remove(at: indexPath.item)
            
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
            }, completion: nil)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .left
        cell.addGestureRecognizer(swipeGesture)
        
        let episode = filteredEpisodes[indexPath.row]
        cell.configure(with: episode)
        cell.heartButton.tag = indexPath.row
        cell.heartButton.addTarget(self, action: #selector(addEpisode(_:)), for: .touchUpInside)
        return cell
    }
    
        var favouritesEpisodeArray = FavouritesArray.shared.favouritesEpisodeArray

    @objc private func addEpisode(_ sender: UIButton) {
        FavouritesArray.shared.favouritesEpisodeArray.append(filteredEpisodes[sender.tag])
    }

    private func showCharacterDetails(_ episode: Episode) {
        
        let detailViewController = CharacterDetailViewController(episode: episode)
        let navController = UINavigationController(rootViewController: detailViewController)
        
        let backButton = UIBarButtonItem(title: "\u{2190} GO BACK", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        detailViewController.navigationItem.leftBarButtonItem = backButton
        let image = UIImage(named: "logoBlack")
        
        let imageButton = UIBarButtonItem(image: image, style: .plain, target: self, action: .none)
        imageButton.tintColor = .black
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
    
    private let searchSeriesField: UITextField = {
        let searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.borderStyle = .roundedRect
        searchField.placeholder = "Name or episode (ex.S01E01)..."
        return searchField
    }()
    
    private let logoView: UIImageView = {
        let logoView = UIImageView(image: UIImage(named: "logo"))
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.contentMode = .scaleAspectFit
        return logoView
    }()
    
    private var collectionView: UICollectionView!
    private var episodes: [Episode] = []
    private var filteredEpisodes: [Episode] = []
    
    private func filterEpisodes(with searchText: String) {
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
    
    private func prepareTopView() {
        view.addSubview(logoView)
        view.addSubview(searchSeriesField)
        searchSeriesField.addTarget(self, action: #selector(searchFieldTextChanged(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            searchSeriesField.topAnchor.constraint(equalTo: logoView.bottomAnchor),
            searchSeriesField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchSeriesField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchSeriesField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        title = "Episodes"
    }
    
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.bounds.width - 20, height: 200) //
        
        view.backgroundColor = .white
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: "EpisodeCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchSeriesField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func loadData() {
        NetworkServices.shared.getEpisodes { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.searchFieldTextChanged(self.searchSeriesField)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTopView()
        prepareCollectionView()
        loadData()
        filterEpisodes(with: "")
    }
}





       
