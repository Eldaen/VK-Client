//
//  NewsCell.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

/// Ячейка для отображения новостей пользователя в контроллере NewsController
final class NewsTableViewCell: UITableViewCell {

	private let userImage: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	
	private let userName: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 17)
		label.textColor = .black
		return label
	}()
	
	private let postDate: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 14)
		label.textColor = .black
		return label
	}()
	
	private let postText: UITextView = {
		let text = UITextView()
		text.translatesAutoresizingMaskIntoConstraints = false
		text.isScrollEnabled = false
		text.autocapitalizationType = .sentences
		text.font = UIFont.systemFont(ofSize: 14)
		text.textColor = .black
		return text
	}()
	
	private let collectionView: UICollectionView = {
		let layout = NewsCollectionViewLayout()
		let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collection.translatesAutoresizingMaskIntoConstraints = false
		return collection
	}()
	
    private var collection: [UIImage] = []
	
	/// Стандартная высота ячейки коллекции
	private var standard: NSLayoutConstraint?
	
	/// Ячейка коллекции, если картинок нет
	private var empty: NSLayoutConstraint?
    
    /// Конфигурирует ячейку NewsTableViewCell
    /// - Parameters:
    ///   - model: Модель новости, которую нужно отобразить
    func configure (with model: NewsTableViewCellModel) {
		setupCell()
		setupCollectionView()
		setupConstraints()
		updateCellData(with: model)
    }
	
	/// Добавляет в collectionView свежезагруженные картинки
	func updateCollection(with images: [UIImage]) {
		self.collection = images
		//reloadCollectionConstraints()
		self.collectionView.reloadData()
	}
}

// MARK: collection view extension
extension NewsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collection.count > 4 {
            return 4
        } else {
            return collection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell",
															for: indexPath) as? NewsCollectionViewCell
		else {
            return UICollectionViewCell()
        }
        
        // TODO: надо это куда-то в модель перенести
        // если есть больше 4х картинок, то нужно показать что их больше
        // для этого сделаем полупрозрачную вьюху, положем её поверх картинки и ещё текст добавим
//        if indexPath.row == 3 && collection.count > 4 {
//            let frameCV = collectionView.frame
//            let cellSize = CGRect(x: 0, y: 0, width: frameCV.width / 2,
//                              height: frameCV.height / 2)
//            
//            let newView = UIView(frame: cellSize)
//            newView.backgroundColor = .white.withAlphaComponent(0.8)
//
//            let extraImagesCount = UILabel(frame: cellSize)
//            extraImagesCount.textAlignment = .center
//            extraImagesCount.text = "+" + String( collection.count - 3 )
//            extraImagesCount.font = UIFont.boldSystemFont(ofSize: 48.0)
//            extraImagesCount.textColor = .black
//
//            cell.newsImage.addSubview(newView)
//            newView.addSubview(extraImagesCount)
//        }
        
        // находим нужную модель ячейки коллекции в массиве collection и потом в нашу новую ячейку коллекции передаэм готовую картинку
        let collectionCell = collection[indexPath.row]
        cell.configure(with: collectionCell)
        
        return cell
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
	}
}

// MARK: - Private methods
private extension NewsTableViewCell {
	
	
	func setupConstraints() {
		
		// Стандартная высота колекции
		standard = collectionView.heightAnchor.constraint(equalToConstant: 300)
		standard?.isActive = true
		
		NSLayoutConstraint.activate([
			userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			userImage.widthAnchor.constraint(equalToConstant: 60),
			userImage.heightAnchor.constraint(equalTo: userImage.widthAnchor, multiplier: 1.0),
			
			userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
			userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
			userName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			
			postDate.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
			postDate.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10),
			
			postText.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 10),
			postText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			postText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			
			collectionView.topAnchor.constraint(equalTo: postText.bottomAnchor, constant: 10),
			collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
		])
	}
	
	func setupCell() {
		contentView.addSubview(userImage)
		contentView.addSubview(userName)
		contentView.addSubview(postDate)
		contentView.addSubview(postText)
		contentView.addSubview(collectionView)
	}
	
	// Конфигурируем нашу collectionView и добавляем в основную view
	func setupCollectionView() {
		collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: "NewsCollectionViewCell")
		collectionView.backgroundColor = .white
		collectionView.dataSource = self
		collectionView.delegate = self
		
		contentView.addSubview(collectionView)
	}
	
	// обновляет данные ячейки
	func updateCellData(with model: NewsTableViewCellModel) {
		userImage.image = UIImage(named: model.source.image)
		userName.text = model.source.name
		self.postDate.text = model.postDate
		postText.text = model.postText
		self.collection = model.collection
		
		self.collectionView.reloadData()
	}
	
	///  Выставляем высоту коллекции
	func reloadCollectionConstraints() {
		
		//let height = collectionView.subviews.reduce(CGRect.zero, {$0.union($1.frame)}).size
		
		standard = collectionView.heightAnchor.constraint(equalToConstant: 350)//height.height)
		empty = collectionView.heightAnchor.constraint(equalToConstant: 0)
		
//		if collection.isEmpty {
//			standard?.isActive = false
//			empty?.isActive = true
//		} else {
//			empty?.isActive = false
//			standard?.isActive = true
//		}
		
		standard?.isActive = true
		
		self.collectionView.layoutIfNeeded()
	}
}
