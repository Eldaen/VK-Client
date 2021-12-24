//
//  NewsLinkCell.swift
//  VK client
//
//  Created by Денис Сизов on 24.12.2021.
//

import UIKit
import Foundation

/// Протокол ячейки автора новости для NewsController
protocol NewsLinkCellType {
	
	/// Конфигурирует ячейку данными для отображения
	func configure (with model: NewsTableViewCellModelType)
}

/// Ячейка для отображения новостей пользователя в контроллере NewsController
final class NewsLinkCell: UITableViewCell, NewsLinkCellType {

	private let linkTitle: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 14)
		label.textColor = .black
		return label
	}()
	
	private let linkCaption: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 12)
		label.textColor = .gray
		return label
	}()
	
	private let linkHorizontalStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fillEqually
		stack.contentMode = .left
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	private let linkImage: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.image = UIImage(systemName: "link")
		image.tintColor = .black
		return image
	}()
	
	lazy var tapGestureRecognizer: UITapGestureRecognizer = {
		let recognizer = UITapGestureRecognizer(target: self,
												action: #selector(onClick))
		recognizer.numberOfTapsRequired = 1
		recognizer.numberOfTouchesRequired = 1
		return recognizer
	}()
	
	/// URL ссылки новости
	private var url: URL?
	
	/// Модель новости, которую отображаем
	private var model: NewsTableViewCellModelType?
	
	/// Конфигурирует ячейку
	/// - Parameters:
	///   - model: Модель новости, которую нужно отобразить
	func configure (with model: NewsTableViewCellModelType) {
		setupCell()
		setupConstraints()
		updateCellData(with: model)
		self.model = model
		addGestureRecognizer(tapGestureRecognizer)
		
		selectionStyle = .none
	}
}

// MARK: - Private methods
private extension NewsLinkCell {
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			linkImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			linkImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			linkImage.heightAnchor.constraint(equalToConstant: 20),
			linkImage.widthAnchor.constraint(equalTo: linkImage.heightAnchor, multiplier: 1.0),
			
			linkHorizontalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			linkHorizontalStack.leadingAnchor.constraint(equalTo: linkImage.trailingAnchor, constant: 8),
			linkHorizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
		])
	}
	
	func setupCell() {
		contentView.addSubview(linkImage)
		
		if (model?.link?.title) != nil {
			linkHorizontalStack.addArrangedSubview(linkTitle)
		}
		linkHorizontalStack.addArrangedSubview(linkCaption)
		contentView.addSubview(linkHorizontalStack)
	}
	
	/// обновляет данные ячейки
	func updateCellData(with model: NewsTableViewCellModelType) {
		linkTitle.text = model.link?.title
		
		if let caption = model.link?.caption {
			linkCaption.text = caption
		} else {
			linkCaption.text = model.link?.url
		}
		
		url = URL(string: model.link?.url ?? "")
	}
	
	@objc func onClick() {
		if let url = url {
			UIApplication.shared.open(url)
		}
	}
}
