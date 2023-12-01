//
//  ViewController.swift
//  RMTest
//
//  Created by Руслан Абрамов on 27.11.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "LoadingComponent"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        let logoView = UIImageView(image: UIImage(named: "logo"))
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.contentMode = .scaleAspectFit
        view.addSubview(logoView)
        
        NSLayoutConstraint.activate([
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height/4),
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotationAnimation.duration = 2.0
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            let tabBarViewController = UITabBarController()
            
            let episodesViewController = EpisodesViewController()
            let favouritesViewController = FavouritesViewController()
            
            tabBarViewController.setViewControllers([episodesViewController, favouritesViewController], animated: false)
            
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


}

