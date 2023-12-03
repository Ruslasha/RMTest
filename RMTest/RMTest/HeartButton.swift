import UIKit

class HeartButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        
        let heartImage = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate).withTintColor(.red)
           let scaledHeartImage = resizeImage(heartImage, targetSize: CGSize(width: 30, height: 30))
        let filledHeartImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate).withTintColor(.red)
           let filledScaledHeartImage = resizeImage(filledHeartImage, targetSize: CGSize(width: 30, height: 30))
        
        setImage(scaledHeartImage, for: .normal)
        setImage(filledScaledHeartImage, for: .highlighted)
//        tintColor = .red
        addTarget(self, action: #selector(animateButton), for: .touchUpInside)

    }
    
    private func resizeImage(_ image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let image = image else {
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let scaledImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return scaledImage
    }
    
    @objc private func animateButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}