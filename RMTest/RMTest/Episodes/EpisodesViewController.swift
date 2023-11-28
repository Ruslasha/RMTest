//
//  EpisodesViewController.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import UIKit

class EpisodesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        
        let episode = episodes[indexPath.item]
        cell.configure(with: episode)
        
        return cell
    }
    
    private func showCharacterDetails() {

        let detailViewController = CharacterDetailViewController()
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
//        let character = characters[indexPath.item]
        showCharacterDetails()
    }


    var collectionView: UICollectionView!
    var episodes: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
        let color = createColor(red: 220, green: 220, blue: 220)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.bounds.width - 20, height: 200) //
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: "EpisodeCell")
        collectionView.backgroundColor = color
        view.addSubview(collectionView)
        
        NetworkServices.shared.getEpisodes { episodes in
                    self.episodes = episodes
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
    }
    
    private func createColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
//    private func showCharacterDetails(_ character: Character) {
//        let detailViewController = CharacterDetailViewController(character: character)
//        
//        present(detailViewController, animated: true, completion: nil)
//    }
}


       
