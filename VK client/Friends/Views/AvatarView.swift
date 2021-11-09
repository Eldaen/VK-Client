//
//  AvatarView.swift
//  VK-Client
//
//  Created by Денис Сизов on 15.10.2021.
//

import UIKit

/// Кастомная вьюшка для аватарки друга
@IBDesignable class AvatarView: UIView {
    
	/// UIImage фотограции
    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
	
    private let imageView: UIImageView = {
		let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	
    private let containerView: UIView = {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	/// Цвет тени
    @IBInspectable var shadowColor: UIColor = .black {
        didSet {
            self.updateColor()
        }
    }
	
	/// Прозрачность тени
    @IBInspectable var shadowOpacity: Float = 3.0 {
        didSet {
            self.updateOpacity()
        }
    }
	
	/// Радиус тени
    @IBInspectable var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.updateRadius()
        }
    }
	
	/// Сдвиг тени
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            self.updateOffset()
        }
    }
    
    /// Запускает анимацию сжатия аватарки
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
    
    /// Устанавливаем жест для активации анимации автарки при нажатию на неё
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(animate))
        recognizer.numberOfTapsRequired = 1    // Количество нажатий, необходимое для распознавания
        recognizer.numberOfTouchesRequired = 1 // Количество пальцев, которые должны коснуться экрана для распознавания
        return recognizer
    }()
    
    private func setupImage() {
        
        // Чтобы тень рисовалась и круглые картинки были
		containerView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        containerView.layer.cornerRadius = 20
        
        //чтобы округлялось
		imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit // если ставить fit, то что-то не то
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.image = image
        
        //вьюхи нужно добавлять только после задания им параметров
        containerView.addSubview(imageView)
        self.addSubview(containerView)
		
		setupContraints()
        updateShadows()
    }
	
	private func setupContraints() {
		NSLayoutConstraint.activate([
			containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			containerView.topAnchor.constraint(equalTo: self.topAnchor),
			containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			
			imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
		])
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
    
	// MARK: - Init
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
