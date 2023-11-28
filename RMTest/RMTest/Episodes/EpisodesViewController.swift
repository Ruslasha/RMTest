//
//  EpisodesViewController.swift
//  RMTest
//
//  Created by Руслан Абрамов on 28.11.2023.
//

import UIKit

class EpisodesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
                
                let character = characters[indexPath.item]
                cell.configure(with: character)
                
                return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        let height: CGFloat = 150
        
        return CGSize(width: width, height: height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let character = characters[indexPath.item]
//        showCharacterDetails(character)
//    }


    var collectionView: UICollectionView!
    var characters: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = createColor(red: 46, green: 46, blue: 46)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.bounds.width - 20, height: 200) //
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "CharacterCell")
        collectionView.backgroundColor = color
        view.addSubview(collectionView)
        
        
        APIManager.shared.getCharacters { characters in
            self.characters = characters
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


       
