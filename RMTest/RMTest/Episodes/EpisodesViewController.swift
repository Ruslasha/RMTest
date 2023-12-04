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
        cell.heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .left
        cell.addGestureRecognizer(swipeGesture)
        
        let episode = filteredEpisodes[indexPath.row]
        cell.configure(with: episode)
        
        return cell
    }
    
    var FavouritesViewController: FavouritesViewController?
    
    @objc func heartButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UICollectionViewCell else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let selectedCell = collectionView.cellForItem(at: indexPath)
        
        let storyboard = UIStoryboard(name: "FavouritesViewController", bundle: nil)
        
        guard let navigationController = self.tabBarController?.viewControllers?[1] as? FavouritesViewController else { return }
        
        navigationController.selectedCell = selectedCell
        self.tabBarController?.selectedViewController = navigationController
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
    
    let searchSeriesField: UITextField = {
        let searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.borderStyle = .roundedRect
        searchField.placeholder = "Name or episode (ex.S01E01)..."
        return searchField
    }()
    
    let logoView: UIImageView = {
        let logoView = UIImageView(image: UIImage(named: "logo"))
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.contentMode = .scaleAspectFit
        return logoView
    }()
    
    var collectionView: UICollectionView!
    var episodes: [Episode] = []
    var filteredEpisodes: [Episode] = []
    var selectedField: String?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let color = createColor(red: 220, green: 220, blue: 220)
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
        
        NetworkServices.shared.getEpisodes { episodes in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.searchFieldTextChanged(self.searchSeriesField)
            }
        }
        filterEpisodes(with: "", selectedField: nil)
        
    }
    
    private func createColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}





       
