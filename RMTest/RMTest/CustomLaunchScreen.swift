//
//  CustomLaunchScreen.swift
//  RMTest
//
//  Created by Руслан Абрамов on 27.11.2023.
//

import UIKit

class CustomLaunchScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Создайте UIImageView и установите желаемое изображение
            let imageView = UIImageView(image: UIImage(named: "LoadingComponent"))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            
            // Добавьте ограничения для расположения в центре
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            // Анимирование вращения по часовой стрелке
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
            rotationAnimation.duration = 2.0
            rotationAnimation.repeatCount = .infinity
            imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")

    }

}
