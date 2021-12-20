//
//  NewsTextCell.swift
//  VK client
//
//  Created by Денис Сизов on 20.12.2021.
//

import UIKit

/// Протокол типа ячейки с текстом для NewsController
protocol TextCellType {
	
	/// Конфигурирует ячейку данными для отображения
	func configure (with model: NewsTableViewCellModelType)
}

/// Ячейка для отображения новостей пользователя в контроллере NewsController
final class NewsTextCell: UITableViewCell, TextCellType {
	
	private let postText: UITextView = {
		let text = UITextView()
		text.inputView = nil
		text.translatesAutoresizingMaskIntoConstraints = false
		text.isScrollEnabled = false
		text.autocapitalizationType = .sentences
		text.font = UIFont.systemFont(ofSize: 14)
		text.textColor = .black
		return text
	}()

	/// Модель новости, которую отображаем
	private var model: NewsTableViewCellModelType?
	
	/// Конфигурирует ячейку NewsTableViewCell
	/// - Parameters:
	///   - model: Модель новости, которую нужно отобразить
	func configure (with model: NewsTableViewCellModelType) {
		setupCell()
		setupConstraints()
		updateCellData(with: model)
		self.model = model
		
		selectionStyle = .none
	}
}

// MARK: - Private methods
private extension NewsTextCell {
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			postText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			postText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			postText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			postText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
		])
	}
	
	func setupCell() {
		contentView.addSubview(postText)
	}
	
	/// обновляет данные ячейки
	func updateCellData(with model: NewsTableViewCellModelType) {
		postText.text = model.postText
	}
}
