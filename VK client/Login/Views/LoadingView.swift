//
//  LoadingView.swift
//  test-gu
//
//  Created by Денис Сизов on 26.10.2021.
//

import UIKit

class loadingView: UIView {
    
    private var stackView: UIStackView!
    private var image = UIImage(systemName: "circle.fill")!
    var color: UIColor = .gray
    var spacing: CGFloat = 15
    
    private func setupView() {
        
        // массив вьюшек с картинками
        var dots = [UIImageView]()
        
        // добавляем туда 3 картинки
        for _ in 0..<3 {
            let imageView = UIImageView()
            imageView.image = image
            imageView.tintColor = color
            
            dots.append(imageView)
        }
        
        stackView = UIStackView(arrangedSubviews: dots)
        self.addSubview(stackView)
        
        // конфигурируем стэк и добавляем туда картинки
        stackView.spacing = spacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.frame = bounds
        stackView.backgroundColor = .clear
        
        // это чтобы отступы внутри стэка задать
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    }
    
    func startAnimation() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       options: [.repeat, .autoreverse],
                       animations: {
            self.stackView.subviews[0].alpha = 0.3
        })
        UIView.animate(withDuration: 0.5,
                       delay: 0.8,
                       options: [.repeat, .autoreverse],
                       animations: {
            self.stackView.subviews[1].alpha = 0.3
        })
        UIView.animate(withDuration: 0.5,
                       delay: 1.1,
                       options: [.repeat, .autoreverse],
                       animations: {
            self.stackView.subviews[2].alpha = 0.3
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        self.setupView()
    }
}
