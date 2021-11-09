//
//  LikeControl.swift
//  VK-Client
//
//  Created by Денис Сизов on 15.10.2021.
//

import UIKit

/// Контрол для отображения вьюшки с лайками и возможность лайкнуть
final class LikeControl: UIControl {
    
    var likesCount: Int = 0
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onClick))
        recognizer.numberOfTapsRequired = 1    // Количество нажатий, необходимое для распознавания
        recognizer.numberOfTouchesRequired = 1 // Количество пальцев, которые должны коснуться экрана для распознавания
        return recognizer
    }()
    
    private var likesImageEmpty: UIImageView = UIImageView()
    private var likesImageFill: UIImageView = UIImageView()
    private var likesLabel: UILabel = UILabel()
    private var bgView: UIView = UIView()
    
    private func setupView() {
        
        // Чтобы вьюха была без фона и не мешала
        self.backgroundColor = .clear
        
        // Задали imageVue картинку heart с цветом red
        let imageEmpty = UIImage(systemName: "heart")
        likesImageEmpty.frame = CGRect(x: 5, y: 1, width: 22, height: 18)
        likesImageEmpty.image = imageEmpty
        likesImageEmpty.tintColor = .red
        
        // Задали imageVue картинку heart.fill с цветом red
        let imageFill = UIImage(systemName: "heart.fill")
        likesImageFill.frame = CGRect(x: 5, y: 1, width: 22, height: 18)
        likesImageFill.image = imageFill
        likesImageFill.tintColor = .red
            
        
        //Настраиваем Label
        likesLabel.frame = CGRect(x: self.frame.size.width - 20, y: 4, width: 10, height: 12)
        likesLabel.text = String(likesCount)
        likesLabel.textAlignment = .center
        likesLabel.textColor = .red
        likesLabel.font = UIFont.systemFont(ofSize: 16)
        
        // нужно создать пустую вью подложку, чтобы на ней анимировались лайки, на сам лайк контрол нельзя
        bgView.frame = bounds
        bgView.addSubview(likesImageEmpty)
        bgView.addSubview(likesLabel)
        
        self.addSubview(bgView)
    }
    
    /// Меняет вью с одной картинкой на вью с другой
    @objc func onClick() {
        if likesCount == 0 {
            self.likesLabel.text = "1"
            likesCount = 1
            
            UIView.transition(from: likesImageEmpty,
                              to: likesImageFill,
                              duration: 0.2,
                              options: .transitionCrossDissolve)
        } else {
            self.likesLabel.text = "0"
            likesCount = 0
            
            UIView.transition(from: likesImageFill,
                              to: likesImageEmpty,
                              duration: 0.2,
                              options: .transitionCrossDissolve)
        }
        likesLabel.text = String(likesCount)
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
