//
//  NewsCollectionCell.swift
//  VK client
//
//  Created by Денис Сизов on 20.12.2021.
//

import UIKit

/// Протокол медиа ячейки для NewsController
protocol NewCollectionCellType {
	
	/// Конфигурирует ячейку данными для отображения
	func configure (with model: NewsTableViewCellModelType)
	
	/// Добавляет в collectionView свежезагруженные картинки
	func updateCollection(with images: [UIImage])
}

/// Ячейка для отображения новостей пользователя в контроллере NewsController
final class NewsCollectionCell: UITableViewCell, NewCollectionCellType {
	
	private let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collection.translatesAutoresizingMaskIntoConstraints = false
		collection.alwaysBounceVertical = false
		return collection
	}()
	
	/// Массив картинок для отображения
	private var collection: [UIImage] = []
	
	/// Стандартная высота ячейки коллекции
	private var standard: NSLayoutConstraint?
	
	/// Ячейка коллекции, если картинок нет
	private var empty: NSLayoutConstraint?
	
	/// Модель новости, которую отображаем
	private var model: NewsTableViewCellModelType?
	
	/// Констрейнт высоты коллекции
	var collectionHeight: NSLayoutConstraint?
	
	/// Конфигурирует ячейку NewsTableViewCell
	/// - Parameters:
	///   - model: Модель новости, которую нужно отобразить
	func configure (with model: NewsTableViewCellModelType) {
		setupCollectionView()
		setupConstraints()
		updateCellData(with: model)
		self.model = model
		
		selectionStyle = .none
	}
	
	/// Добавляет в collectionView свежезагруженные картинки
	func updateCollection(with images: [UIImage]) {
		collection = images
		
		let layout = getCollectionLayout(isMultiple: collection.count > 1)
		collectionView.collectionViewLayout = layout
		collectionView.reloadData()
	}
}

// MARK: collection view extension
extension NewsCollectionCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collection.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell",
															for: indexPath) as? NewsCollectionViewCell
		else {
			return UICollectionViewCell()
		}
		
		// находим нужную модель ячейки коллекции в массиве collection и потом в нашу новую ячейку коллекции передаэм готовую картинку
		let collectionCell = collection[indexPath.row]
		cell.configure(with: collectionCell)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let link = collectionView.dequeueReusableSupplementaryView(
			ofKind: kind,
			withReuseIdentifier: LinkView.reuseIdentifier, for: indexPath
		) as? LinkView else {
			return UICollectionReusableView()
		}
		link.label.text = "LINK for index \(indexPath.section)"
		return link
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumInteritemSpacingForSectionAt section: Int
	) -> CGFloat {
		return 0
	}
	
	override func prepareForReuse() {
		standard = nil
		empty = nil
		model = nil
		collection = []
	}
}

// MARK: - Private methods
private extension NewsCollectionCell {
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
		
		collectionHeight = collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
		collectionHeight?.isActive = true
	}
	
	/// Конфигурируем нашу collectionView и добавляем в основную view
	func setupCollectionView() {
		collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: "NewsCollectionViewCell")
		collectionView.register(LinkView.self, forSupplementaryViewOfKind: "Link", withReuseIdentifier: LinkView.reuseIdentifier)
		collectionView.backgroundColor = .white
		collectionView.dataSource = self
		collectionView.delegate = self
		
		contentView.addSubview(collectionView)
	}
	
	/// обновляет данные ячейки
	func updateCellData(with model: NewsTableViewCellModelType) {
		collection = model.collection
		
		self.collectionView.reloadData()
	}
	
	/// Генерирует Сomposition Layout для нашей коллекции
	func getCollectionLayout(isMultiple: Bool) -> UICollectionViewCompositionalLayout {
		
		let image = collection.first ?? UIImage()
		let aspectRatio = image.size.height / image.size.width
		
		let itemSize = NSCollectionLayoutSize(
		  widthDimension: .fractionalWidth(1.0),
		  heightDimension: .fractionalHeight(1.0))
		
		let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(isMultiple ? 0.95 : 1.0),
		  heightDimension: .fractionalWidth(aspectRatio))
		
		let group = NSCollectionLayoutGroup.horizontal(
		  layoutSize: groupSize,
		  subitem: fullPhotoItem,
		  count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(
		  top: 5,
		  leading: 5,
		  bottom: 5,
		  trailing: 5)
		
		group.supplementaryItems = [createLinkItem()]
		
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
		
		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}
	
	/// Cоздаёт SupplementaryView для ссылки из новости
	private func createLinkItem() -> NSCollectionLayoutSupplementaryItem {
		let bottomAnchor = NSCollectionLayoutAnchor(edges: [.bottom, .leading, .trailing], fractionalOffset: CGPoint(x: 0, y: 0.3))
		
		let item = NSCollectionLayoutSupplementaryItem(
			layoutSize: .init(
				widthDimension: .fractionalWidth(1.05),
				heightDimension: .estimated(20)
			),
			elementKind: "Link",
			containerAnchor: bottomAnchor
		)
		
		return item
	}
}

