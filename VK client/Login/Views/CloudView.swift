//
//  CloudView.swift
//  VK-Client
//
//  Created by Денис Сизов on 05.11.2021.
//

import UIKit

class CloudView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	func setupView() {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 10, y: 60))
		path.addQuadCurve(to: CGPoint(x: 20, y: 40), controlPoint: CGPoint(x: 5, y: 50))
		path.addQuadCurve(to: CGPoint(x: 40, y: 20), controlPoint: CGPoint(x: 20, y: 20))
		path.addQuadCurve(to: CGPoint(x: 70, y: 20), controlPoint: CGPoint(x: 55, y: 0))
		path.addQuadCurve(to: CGPoint(x: 90, y: 30), controlPoint: CGPoint(x: 85, y: 15))
		path.addQuadCurve(to: CGPoint(x: 110, y: 60), controlPoint: CGPoint(x: 110, y: 35))
		path.close()

		let layerAnimation = CAShapeLayer()
		layerAnimation.path = path.cgPath
		layerAnimation.strokeColor = UIColor.white.cgColor
		layerAnimation.fillColor = UIColor.systemBlue.cgColor
		layerAnimation.lineWidth = 8
		layerAnimation.lineCap = .round

		self.layer.addSublayer(layerAnimation)

		let pathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
		pathAnimationEnd.fromValue = 0
		pathAnimationEnd.toValue = 1
		pathAnimationEnd.duration = 2
		pathAnimationEnd.fillMode = .both
		pathAnimationEnd.isRemovedOnCompletion = false
		layerAnimation.add(pathAnimationEnd, forKey: nil)

		let pathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
		pathAnimationStart.fromValue = 0
		pathAnimationStart.toValue = 1
		pathAnimationStart.duration = 2
		pathAnimationStart.fillMode = .both
		pathAnimationStart.isRemovedOnCompletion = false
		pathAnimationStart.beginTime = 1

		let animationGroup = CAAnimationGroup()
		animationGroup.duration = 3
		animationGroup.fillMode = CAMediaTimingFillMode.backwards
		animationGroup.animations = [pathAnimationEnd, pathAnimationStart]
		animationGroup.repeatCount = .infinity
		layerAnimation.add(animationGroup, forKey: nil)
	}
}
