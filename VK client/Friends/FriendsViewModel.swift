//
//  FriendsViewModel.swift
//  VK client
//
//  Created by Денис Сизов on 25.11.2021.
//

import UIKit.UIImage
import RealmSwift

/// Протокол вью модели для контроллера Friends
protocol FriendsViewModelType {
	
	/// Список друзей текущего пользователя
	var friends: Results<UserModel>? { get }
	
	/// Cписок друзей текущего пользователя, которые подходят под поисковой запрос
	var filteredData: [FriendsSection] { get }
	
	/// Сервис по загрузке данных пользователей
	var loader: UserLoader { get }
	
	/// Список букв для заголовков секций
	var lettersOfNames: [String] { get }
	
	/// Конфигурируем ячейку друга для отображения
	func configureCell(cell: FriendsTableViewCell, indexPath: IndexPath)
	
	/// Скачиваем из сети список друзей пользователя
	func fetchFriends(completion: @escaping () -> Void)
	
	/// Осуществляет поиск друзей среди списка друзей пользователя по введённому тексту
	func search(_ text: String, completion: @escaping () -> Void)
	
	/// Осуществляет действия после нажатия кнопки отмены поиска
	func cancelSearch(completion: @escaping() -> Void)
}

/// Вью модель для контроллера Friends
final class FriendsViewModel: FriendsViewModelType {
	var friends: Results<UserModel>?
	var filteredData: [FriendsSection] = []
	var lettersOfNames: [String] = []
	
	var loader: UserLoader
	
	private let realm = RealmService()
	
	init(loader: UserLoader){
		self.loader = loader
	}
	
	func configureCell(cell: FriendsTableViewCell, indexPath: IndexPath) {
		let name = friends?[indexPath.row].name
		let image = friends?[indexPath.row].image
		
		// конфигурируем и возвращаем готовую ячейку
		cell.configure(name: name ?? "", image: UIImage())
		
		// Ставим картинку на загрузку
		loader.loadImage(url: image ?? "") { image in
			cell.updateImage(with: image)
		}
	}
	
	func fetchFriends(completion: @escaping () -> Void) {
		loader.loadFriends() { [weak self] friends in
			self?.realm.read(UserModel.self) { [weak self] result in
				self?.friends = result
			}
			completion()
		}
	}
	
	func search(_ text: String, completion: @escaping () -> Void) {
		
		fetchFriends { }
		
		// Если строка поиска пустая, то показываем все группы
		if text == "" {
			fetchFriends { }
		} else {
			friends = realm.realm.objects(UserModel.self).filter("name CONTAINS %@", "\(text.lowercased())")
			completion()
		}
	}
	
	func cancelSearch(completion: @escaping () -> Void) {
		fetchFriends { }
		completion()
	}
}

// MARK: - Private methods
private extension FriendsViewModel {
	
//	/// Cоздаёт массив  букв для заголовков секций
//	func loadLetters() {
//		for user in friends {
//			lettersOfNames.append(String(user.key))
//		}
//	}
}
