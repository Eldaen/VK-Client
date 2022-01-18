//
//  NewsFooterCell.swift
//  VK client
//
//  Created by Денис Сизов on 20.12.2021.
//

import UIKit

/// Протокол ячейки футера новости для NewsController
protocol NewsFooterCellType {
	
	/// Конфигурирует ячейку данными для отображения
	func configure (with model: NewsTableViewCellModelType)
	
	/// Обработчик лайков
	var likesResponder: NewsViewModelType? { get set }
}

/// Ячейка для отображения новостей пользователя в контроллере NewsController
final class NewsFooterCell: UITableViewCell, NewsFooterCellType {

	private let footerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let footerHorizontalStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		stack.contentMode = .center
		stack.spacing = 20
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	private let likesControl: LikeControl = {
		let likeControl = LikeControl(frame: .zero)
		likeControl.tintColor = .red
		return likeControl
	}()
	
	private let commentsControl: CommentsControl = {
		let comments = CommentsControl(frame: .zero)
		return comments
	}()
	
	private let repostsControl: RepostsControl = {
		let reposts = RepostsControl(frame: .zero)
		return reposts
	}()
	
	private let viewsLabel: UILabel = {
		let views = UILabel(frame: .zero)
		views.font = UIFont.systemFont(ofSize: 14)
		views.translatesAutoresizingMaskIntoConstraints = false
		return views
	}()

	/// Модель новости, которую отображаем
	private var model: NewsTableViewCellModelType?
	
	/// Вью модель
	var likesResponder: NewsViewModelType?
	
	/// Конфигурирует ячейку NewsTableViewCell
	/// - Parameters:
	///   - model: Модель новости, которую нужно отобразить
	func configure (with model: NewsTableViewCellModelType) {
		setupCell()
		setupFooter()
		setupConstraints()
		
		self.model = model
		updateCellData(with: model)
		
		selectionStyle = .none
		likesControl.setLikesResponder(responder: self)
	}
}

// MARK: - Private methods
private extension NewsFooterCell {
	
	func setupConstraints() {
		
		NSLayoutConstraint.activate([
			footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			footerView.heightAnchor.constraint(equalToConstant: 30),
			
			footerHorizontalStack.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
			footerHorizontalStack.trailingAnchor.constraint(lessThanOrEqualTo: viewsLabel.leadingAnchor, constant: -10),
			footerHorizontalStack.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
			
			viewsLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -10),
			viewsLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
		])
		
		let footerTop = footerView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20)
		footerTop.priority = .init(rawValue: 999)
		footerTop.isActive = true
	}
	
	func setupCell() {
		contentView.addSubview(footerView)
	}
	
	/// Конфигурируем футер
	func setupFooter() {
		footerHorizontalStack.addArrangedSubview(likesControl)
		footerHorizontalStack.addArrangedSubview(commentsControl)
		footerHorizontalStack.addArrangedSubview(repostsControl)
		footerView.addSubview(viewsLabel)
		footerView.addSubview(footerHorizontalStack)
	}
	
	/// обновляет данные ячейки
	func updateCellData(with model: NewsTableViewCellModelType) {
		likesControl.setCount(with: model.likesModel?.count ?? 0)
		commentsControl.setCount(with: model.comments?.count ?? 0)
		commentsControl.setImage(with: "bubble.left")
		repostsControl.setCount(with: model.reposts?.count ?? 0)
		repostsControl.setImage(with: "arrowshape.turn.up.right")
		viewsLabel.text = "🔍 \(model.views?.count ?? 0)"
	}
}

// MARK: - CanLike protocol extension

extension NewsFooterCell: CanLike {
	
	///  Отправляет запрос на лайк поста
	func setLike() {
		if let id = model?.postID,
		   let ownerId = model?.source.id {
			likesResponder?.setLike(post: id, owner: ownerId) { [weak self] result in
				self?.likesControl.setCount(with: result)
			}
		}
	}
	
	/// Отправляет запрос на отмену лайка
	func removeLike() {
		if let id = model?.postID,
		   let ownerId = model?.source.id {
			likesResponder?.setLike(post: id, owner: ownerId) { [weak self] result in
				self?.likesControl.setCount(with: result)
			}
		}
	}
}
