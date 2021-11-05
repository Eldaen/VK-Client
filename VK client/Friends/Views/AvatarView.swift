//
//  AvatarView.swift
//  test-gu
//
//  Created by Денис Сизов on 15.10.2021.
//

import UIKit

@IBDesignable class AvatarView: UIView {
    
    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    private var imageView: UIImageView = UIImageView()
    private var containerView: UIView = UIView()
    
    @IBInspectable var shadowColor: UIColor = .black {
        didSet {
            self.updateColor()
        }
    }
    @IBInspectable var shadowOpacity: Float = 3.0 {
        didSet {
            self.updateOpacity()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.updateRadius()
        }
    }
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            self.updateOffset()
        }
    }
    
    // заставляет аватарки сжиматься
    @objc func animate() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [],
                       animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        })
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 70,
                       options: [],
                       animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    // распознаём нажатие по аватарке
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(animate))
        recognizer.numberOfTapsRequired = 1    // Количество нажатий, необходимое для распознавания
        recognizer.numberOfTouchesRequired = 1 // Количество пальцев, которые должны коснуться экрана для распознавания
        return recognizer
    }()
    
    private func setupImage() {
        
        // Чтобы тень рисовалась и круглые картинки были
        containerView.frame = self.bounds
        containerView.layer.cornerRadius = 20
        
        //чтобы округлялось
        imageView.layer.masksToBounds = true
        imageView.frame = containerView.bounds
        imageView.contentMode = .scaleAspectFill // если ставить fit, то что-то не то
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.image = image
        
        //вьюхи нужно добавлять только после задания им параметров
        containerView.addSubview(imageView)
        self.addSubview(containerView)
        updateShadows()
    }
    
    private func updateOpacity() {
        
        self.containerView.layer.shadowOpacity = shadowOpacity
    }
    
    private func updateColor() {
        self.containerView.layer.shadowColor = shadowColor.cgColor
    }
    
    private func updateOffset() {
        self.containerView.layer.shadowOffset = shadowOffset
    }
    
    private func updateRadius() {
        self.containerView.layer.shadowRadius = shadowRadius
    }
    
    private func updateShadows() {
        self.containerView.layer.shadowOpacity = shadowOpacity
        self.containerView.layer.shadowColor = shadowColor.cgColor
        self.containerView.layer.shadowOffset = shadowOffset
        self.containerView.layer.shadowRadius = shadowRadius
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImage()
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        self.setupImage()
        addGestureRecognizer(tapGestureRecognizer)
    }
    
}
