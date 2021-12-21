//
//  RepostsControl.swift
//  VK client
//
//  Created by Денис Сизов on 21.12.2021.
//

import UIKit

/// Контрол для отображения вьюшки с лайками и возможность лайкнуть
final class RepostsControl: UIControl {
	
	override var intrinsicContentSize: CGSize {
		return CGSize(width: 50, height: 30)
	}
	
	var repostsCount: Int = 0
	
	lazy var tapGestureRecognizer: UITapGestureRecognizer = {
		let recognizer = UITapGestureRecognizer(target: self,
												action: #selector(onClick))
		recognizer.numberOfTapsRequired = 1    // Количество нажатий, необходимое для распознавания
		recognizer.numberOfTouchesRequired = 1 // Количество пальцев, которые должны коснуться экрана для распознавания
		return recognizer
	}()
	
	private var repostImage: UIImageView = UIImageView()
	private var label: UILabel = UILabel()
	private var bgView: UIView = UIView()
	
	private func setupView() {
		
		// Чтобы вьюха была без фона и не мешала
		self.backgroundColor = .clear
		
		// Задали imageVue картинку heart с цветом red
		let image = UIImage(systemName: "arrowshape.turn.up.right")
		repostImage.frame = CGRect(x: 5, y: 5, width: 24, height: 21)
		repostImage.image = image
		repostImage.tintColor = .black
		
		//Настраиваем Label
		label.frame = CGRect(x: 30, y: 8, width: 50, height: 12)
		label.text = String(repostsCount)
		label.textAlignment = .left
		label.font = UIFont.systemFont(ofSize: 16)
		
		// нужно создать пустую вью подложку, чтобы на ней анимировались лайки, на сам лайк контрол нельзя
		bgView.frame = bounds
		bgView.addSubview(repostImage)
		bgView.addSubview(label)
		
		self.addSubview(bgView)
	}
	
	/// Обновляет текущее кол-во лайков
	func setReposts(with value: Int) {
		repostsCount = value
		label.text = "\(value)"
		label.layoutIfNeeded()
	}
	
	/// Отправляет в ячейку информацию о том, что кто-то что-то лайкнул
//	func setClickResponder(responder: CanLike) {
//		self.responder = responder
//	}
	
	/// Меняет вью с одной картинкой на вью с другой
	@objc func onClick() {
		
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
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupView()
		addGestureRecognizer(tapGestureRecognizer)
	}
}
