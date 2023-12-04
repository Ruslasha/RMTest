//
//  ViewController.swift
//  RMTest
//
//  Created by Руслан Абрамов on 27.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "LoadingComponent"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let logoView: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    
    private func prepareImages() {
        
        view.addSubview(imageView)
        view.addSubview(logoView)
        
        NSLayoutConstraint.activate([
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height/4),
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
    }
    
    private func prepareAnimationsImages() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotationAnimation.duration = 2.0
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func prepareTabBar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            let tabBarViewController = UITabBarController()
            
            let episodesViewController = EpisodesViewController()
            let favouritesViewController = FavouritesViewController()
            
            tabBarViewController.setViewControllers([episodesViewController, favouritesViewController], animated: false)
            tabBarViewController.tabBar.isTranslucent = false
            tabBarViewController.tabBar.backgroundColor = .white
            guard let items = tabBarViewController.tabBar.items else {
                return
            }
            
            let images = ["house", "star"]
            
            items[0].image = UIImage(systemName: images[0])
            items[1].image = UIImage(systemName: images[1])
            
            tabBarViewController.modalPresentationStyle = .fullScreen
            self.present(tabBarViewController, animated: false)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareImages()
        prepareAnimationsImages()
        prepareTabBar()
    }
}

