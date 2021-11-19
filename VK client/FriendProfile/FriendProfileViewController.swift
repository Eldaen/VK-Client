//
//  FriendCollectionController.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Контроллер профиля пользователя
final class FriendProfileViewController: UIViewController {
    
	private let userAvatar: UIImageView = {
		let avatar = UIImageView()
		avatar.translatesAutoresizingMaskIntoConstraints = false
		return avatar
	}()
	
	private let friendName: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 17)
		label.textColor = .black
		return label
	}()
	
	private let friendsCount: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 15)
		label.textColor = .black
		label.text = "300"
		return label
	}()
	
	private let friendsText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 15)
		label.textColor = .black
		label.text = "Друзья"
		return label
	}()
	
	private let photosText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 15)
		label.textColor = .black
		label.text = "Фото"
		return label
	}()
	
	private let photosCount: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 15)
		label.textColor = .black
		return label
	}()
	
	private let leftStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fillEqually
		stack.alignment = .center
		stack.spacing = 4
		stack.contentMode = .scaleToFill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	private let rightStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .fillEqually
		stack.alignment = .center
		stack.spacing = 4
		stack.contentMode = .scaleToFill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	private let horizontalStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		stack.alignment = .fill
		stack.spacing = 50
		stack.contentMode = .scaleToFill
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	private let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collection.translatesAutoresizingMaskIntoConstraints = false
		
		return collection
	}()
    
	/// Модель друга, чей профиль открыт
    var friend: UserModel!
	
	/// Массив картинок пользователя
	var storedImages: [UIImage] = []
	
	/// Сервис по загрузке данных
	let loader = UserService()
	
    private let identifier = "PhotoCollectionViewCell"
    
    /// Количество колонок
    private let cellsCount: CGFloat = 3.0
	
	/// Отступы между фото
    private let cellsOffset: CGFloat = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Профиль"
		setupView()
		setupCollectionView()
		setupConstaints()
		
		// Вызываем загрузку картинок, которые есть у пользователя
		loader.loadUserPhotos(for: String(friend.id)) { [weak self] images in
			self?.storedImages = []
			self?.photosCount.text = String(images.count)
			
			// Обновляем таблицу свежими данными
			self?.collectionView.reloadData()
		}
		
        // заполняем статичные данные
        userAvatar.image = UIImage(named: friend.image)
        photosCount.text = "0"
		friendName.text = friend.name
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension FriendProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0 //friend.storedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //cell.configure(with: friend.storedImages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frameCV = collectionView.frame

        let cellWidth = frameCV.width / cellsCount
        let cellHeight = cellWidth

        // считаем размеры ячеек с учётом отступов, чтобы всё ровненько было
        let spacing = ( cellsCount + 1 ) * cellsOffset / cellsCount
        return CGSize(width: cellWidth - spacing, height: cellHeight - ( cellsOffset * 2) )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FullscreenViewController()
        
        vc.photos = [UIImage]() //friend.storedImages
        vc.selectedPhoto = indexPath.item
        
        // переход на подробный просмотр
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Private methods
private extension FriendProfileViewController {
	
	/// Конфигурируем нашу collectionView и добавляем в основную view
	func setupCollectionView() {
		collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
		collectionView.backgroundColor = .white
		collectionView.dataSource = self
		collectionView.delegate = self
		
		self.view.addSubview(collectionView)
	}
	
	/// Добавляет вьюхи в основную вью, все кроме collectionView
	func setupView() {
		view.backgroundColor = .white
		view.addSubview(userAvatar)
		view.addSubview(friendName)
		
		leftStack.addArrangedSubview(friendsCount)
		leftStack.addArrangedSubview(friendsText)
		
		rightStack.addArrangedSubview(photosCount)
		rightStack.addArrangedSubview(photosText)
		
		horizontalStack.addArrangedSubview(leftStack)
		horizontalStack.addArrangedSubview(rightStack)
		
		view.addSubview(horizontalStack)
	}
	
	func setupConstaints() {
		NSLayoutConstraint.activate([
			userAvatar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 15),
			userAvatar.widthAnchor.constraint(equalToConstant: 100),
			userAvatar.heightAnchor.constraint(equalTo: userAvatar.widthAnchor, multiplier: 1.0),
			userAvatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),

			friendName.topAnchor.constraint(equalTo: userAvatar.bottomAnchor, constant: 20),
			friendName.centerXAnchor.constraint(equalTo: userAvatar.centerXAnchor),
			
			leftStack.heightAnchor.constraint(equalToConstant: 50),
			rightStack.heightAnchor.constraint(equalToConstant: 50),

			horizontalStack.topAnchor.constraint(equalTo: friendName.bottomAnchor, constant: 20),
			horizontalStack.heightAnchor.constraint(equalToConstant: 50),
			horizontalStack.widthAnchor.constraint(equalToConstant: 160),
			horizontalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

			collectionView.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 16),
			collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16),
			collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
		])
	}
}

