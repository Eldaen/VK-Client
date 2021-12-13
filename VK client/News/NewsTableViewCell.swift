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
		text.inputView = nil
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
	
	private let footerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let likesControl: LikeControl = {
		let likeControl = LikeControl(frame: CGRect(x: 5, y: 0, width: 100, height: 20))
		likeControl.tintColor = .red
		return likeControl
	}()
	
	private let viewsLabel: UILabel = {
		let views = UILabel(frame: CGRect(x: 105, y: 0, width: 100, height: 20))
		views.font = UIFont.systemFont(ofSize: 18)
		return views
	}()
	
	/// Массив картинок для отображения
    private var collection: [UIImage] = []
	
	/// Стандартная высота ячейки коллекции
	private var standard: NSLayoutConstraint?
	
	/// Ячейка коллекции, если картинок нет
	private var empty: NSLayoutConstraint?
	
	/// Модель новости, которую отображаем
	private var model: NewsTableViewCellModel?
	
	/// Вью модель
	var likesResponder: NewsViewModelType?
	
	/// Констрейнт высоты коллекции
	var collectionHeight: NSLayoutConstraint?
	
	/// Значение высоты коллекции
	var collectionHeightValue: CGFloat = 270
	
	/// Обновлённая высота
	var newHeight: NSLayoutConstraint?
    
    /// Конфигурирует ячейку NewsTableViewCell
    /// - Parameters:
    ///   - model: Модель новости, которую нужно отобразить
    func configure (with model: NewsTableViewCellModel) {
		setupCell()
		setupCollectionView()
		setupFooter()
		setupConstraints()
		updateCellData(with: model)
		self.model = model
		
		likesControl.setLikesResponder(responder: self)
    }
	
	/// Добавляет в collectionView свежезагруженные картинки
	func updateCollection(with images: [UIImage]) {
		collection = images
		//countHeight(images: images)
		collectionView.reloadData()
	}
	
	/// Устанавливает картинку профиля, после того как она загрузится
	func updateProfileImage(with image: UIImage) {
		userImage.image = image
		userImage.layoutIfNeeded()
		userImage.layer.cornerRadius = userImage.frame.size.width / 2
		userImage.layer.masksToBounds = true
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
		model = nil
		collection = []
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if let newHeight = newHeight {
			newHeight.isActive = false
		}
		collectionHeight?.isActive = false

		newHeight = collectionView.heightAnchor.constraint(equalToConstant: collectionHeightValue)
		newHeight?.isActive = true
	}
}

// MARK: - Private methods
private extension NewsTableViewCell {
	
	func setupConstraints() {
		
		NSLayoutConstraint.activate([
			userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			userImage.widthAnchor.constraint(equalToConstant: 60),
			userImage.heightAnchor.constraint(equalToConstant: 60),
			
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
			collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
			
			footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
			footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
			footerView.heightAnchor.constraint(equalToConstant: 30),
		])
		
		collectionHeight = collectionView.heightAnchor.constraint(equalToConstant: collectionHeightValue)
		collectionHeight?.isActive = true
	}
	
	func setupCell() {
		contentView.addSubview(userImage)
		contentView.addSubview(userName)
		contentView.addSubview(postDate)
		contentView.addSubview(postText)
		contentView.addSubview(collectionView)
		contentView.addSubview(footerView)
	}
	
	/// Конфигурируем нашу collectionView и добавляем в основную view
	func setupCollectionView() {
		collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: "NewsCollectionViewCell")
		collectionView.backgroundColor = .white
		collectionView.dataSource = self
		collectionView.delegate = self
		
		contentView.addSubview(collectionView)
	}
	
	/// Конфигурируем футер
	func setupFooter() {
		footerView.addSubview(likesControl)
		footerView.addSubview(viewsLabel)
	}
	
	/// обновляет данные ячейки
	func updateCellData(with model: NewsTableViewCellModel) {
		userImage.image = UIImage(named: model.source.image)
		userName.text = model.source.name
		postDate.text = model.postDate
		postText.text = model.postText
		collection = model.collection
		
		likesControl.setLikes(with: model.likesModel?.count ?? 0)
		viewsLabel.text = "🔍 \(model.views?.count ?? 0)"
		
		self.collectionView.reloadData()
	}
	
	/// Cчитаем высоту коллекции, если там одна картинка
	func countHeight(images: [UIImage]) {
		if images.count == 1 {
			let image = images[0]
			let ratio = image.size.height / image.size.width
			
			if ratio < 1 {
				collectionHeightValue = self.collectionView.frame.width * ratio
			} else {
				collectionHeightValue = self.collectionView.frame.width / ratio
			}
		}
	}
}

// MARK: - CanLike protocol extension

extension NewsTableViewCell: CanLike {
	
	///  Отправляет запрос на лайк поста
	func setLike() {
		if let id = model?.postID,
		   let ownerId = model?.source.id {
			likesResponder?.setLike(post: id, owner: ownerId) { [weak self] result in
				self?.likesControl.setLikes(with: result)
			}
		}
	}
	
	/// Отправляет запрос на отмену лайка
	func removeLike() {
		if let id = model?.postID,
		   let ownerId = model?.source.id {
			likesResponder?.removeLike(post: id, owner: ownerId)
		}
	}
}
