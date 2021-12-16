//
//  NewsCollectionViewCell.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

/// Класс ячейки фотографии для новости
final class NewsCollectionViewCell: UICollectionViewCell {
    
	/// Основная вью с картинкой
	private let newsImage: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.clipsToBounds = true
		image.contentMode = .scaleAspectFit
		return image
	}()
	
	/// Конфигурирует ячейку
	func configure(with image: UIImage) {
		contentView.addSubview(newsImage)
		newsImage.image = image
		setupConstraints()
	}
	
	/// Констрейнт высоты
	private var heightConstraint: NSLayoutConstraint?
	
	/// Выставляет новую высоту для contentView
	func setNewHeight(_ value: CGFloat) {
		heightConstraint = contentView.heightAnchor.constraint(equalToConstant: value)
		heightConstraint?.isActive = true
		newsImage.layoutIfNeeded()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			newsImage.topAnchor.constraint(equalTo: contentView.topAnchor),
			newsImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			newsImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			newsImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
		])
	}
	
	override func prepareForReuse() {
		newsImage.image = nil
	}
}
