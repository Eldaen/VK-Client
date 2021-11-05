//
//  GradientView.swift
//  test-gu
//
//  Created by Денис Сизов on 21.10.2021.
//

import UIKit

class GradientView: UIView {
    
    // Поменяли обычный layer на GradientLayer чтобы делать фон градиентом
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // Переменная для удобго доступа к layer
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    
}
