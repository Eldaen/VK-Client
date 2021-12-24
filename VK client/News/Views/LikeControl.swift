//
//  LikeControl.swift
//  VK-Client
//
//  Created by Денис Сизов on 15.10.2021.
//

import UIKit

/// Протокол описывающий класс, который будет что-то делать с фактом нажатия кноки лайк
protocol CanLike {
	func setLike()
	func removeLike()
}

/// Контрол для отображения вьюшки с лайками и возможность лайкнуть
final class LikeControl: NewsControl {
	
	override var intrinsicContentSize: CGSize {
		return CGSize(width: 50, height: 30)
	}
    
	var responder: CanLike?
	
	private var myLike: Bool = false
    
    private var likesImageEmpty: UIImageView = UIImageView()
    private var likesImageFill: UIImageView = UIImageView()
    private var likesLabel: UILabel = UILabel()
    private var bgView: UIView = UIView()
    
	override func setupView() {
        
        // Чтобы вьюха была без фона и не мешала
        self.backgroundColor = .clear
        
        // Задали imageVue картинку heart с цветом red
        let imageEmpty = UIImage(systemName: "heart")
        likesImageEmpty.frame = CGRect(x: 5, y: 5, width: 24, height: 21)
        likesImageEmpty.image = imageEmpty
        likesImageEmpty.tintColor = .red
        
        // Задали imageVue картинку heart.fill с цветом red
        let imageFill = UIImage(systemName: "heart.fill")
        likesImageFill.frame = CGRect(x: 5, y: 5, width: 24, height: 21)
        likesImageFill.image = imageFill
        likesImageFill.tintColor = .red
            
        
        //Настраиваем Label
        likesLabel.frame = CGRect(x: 30, y: 8, width: 50, height: 12)
        likesLabel.text = String(count)
        likesLabel.textAlignment = .left
        likesLabel.textColor = .red
        likesLabel.font = UIFont.systemFont(ofSize: 16)
        
        // нужно создать пустую вью подложку, чтобы на ней анимировались лайки, на сам лайк контрол нельзя
        bgView.frame = bounds
        bgView.addSubview(likesImageEmpty)
        bgView.addSubview(likesLabel)
        
        self.addSubview(bgView)
    }
	
	/// Отправляет в ячейку информацию о том, что кто-то что-то лайкнул
	func setLikesResponder(responder: CanLike) {
		self.responder = responder
	}
	
	/// Задаёт кол-во лайков счётчику
	override func setCount(with value: Int) {
		count = value
		likesLabel.text = "\(value)"
		likesLabel.layoutIfNeeded()
	}
    
    /// Меняет вью с одной картинкой на вью с другой
    @objc override func onClick() {
        if myLike == false {
            self.likesLabel.text = "\(count + 1)"
            count += 1
			myLike = true
			responder?.setLike()
            
            UIView.transition(from: likesImageEmpty,
                              to: likesImageFill,
                              duration: 0.2,
                              options: .transitionCrossDissolve)
        } else {
            self.likesLabel.text = "\(count - 1)"
            count -= 1
			myLike = false
			responder?.removeLike()
            
            UIView.transition(from: likesImageFill,
                              to: likesImageEmpty,
                              duration: 0.2,
                              options: .transitionCrossDissolve)
        }
        likesLabel.text = String(count)
    }
	
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let frame = self.bounds.insetBy(dx: -20, dy: -20)
		return frame.contains(point) ? self : nil
	}
    
  // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Стандартный метод, надо бы потом разобраться что такое coder.
    // UPD, init? это failable initializer, используется, когда что-то может и не создаться и надо вернуть nil. При создании получим опциональный тип того что создавалось.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        addGestureRecognizer(tapGestureRecognizer)
    }
}
