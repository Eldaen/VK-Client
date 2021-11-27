//
//  FriendsViewModel.swift
//  VK client
//
//  Created by Денис Сизов on 25.11.2021.
//

import UIKit.UIImage

/// Протокол вью модели для контроллера Friends
protocol FriendsViewModelType {
	
	/// Список друзей текущего пользователя
	var friends: [FriendsSection] { get }
	
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
	var friends: [FriendsSection] = []
	var filteredData: [FriendsSection] = []
	var lettersOfNames: [String] = []
	
	var loader: UserLoader
	
	init(loader: UserLoader){
		self.loader = loader
	}
	
	func configureCell(cell: FriendsTableViewCell, indexPath: IndexPath) {
		let section = filteredData[indexPath.section]
		let name = section.data[indexPath.row].name
		let image = section.data[indexPath.row].image
		
		// конфигурируем и возвращаем готовую ячейку
		cell.configure(name: name, image: UIImage())
		
		// Ставим картинку на загрузку
		loader.loadImage(url: image) { image in
			cell.updateImage(with: image)
		}
	}
	
	func fetchFriends(completion: @escaping () -> Void) {
		loader.loadFriends() { [weak self] friends in
			self?.friends = friends
			self?.filteredData = friends
			
			// наполянем имена заголовков секций
			self?.loadLetters()

			completion()
		}
	}
	
	func search(_ text: String, completion: @escaping () -> Void) {
		
		//занулим для повторных поисков
		filteredData = []
		
		// Если поиск пустой, то ничего фильтровать нам не нужно
		if text == "" {
			filteredData = friends
			completion()
		} else {
			for section in friends { // сначала перебираем массив секций с друзьями
				for (_, friend) in section.data.enumerated() { // потом перебираем массивы друзей в секциях
					if friend.name.lowercased().contains(text.lowercased()) { // Ищем в имени нужный текст, оба текста сравниваем в нижнем регистре
						var searchedSection = section
						
						// Если фильтр пустой, то можно сразу добавлять
						if filteredData.isEmpty {
							searchedSection.data = [friend]
							filteredData.append(searchedSection)
							break
						}
						
						// Если в массиве секций уже есть секция с таким ключом, то нужно к имеющемуся массиву друзей добавить друга
						var found = false
						for (sectionIndex, filteredSection) in filteredData.enumerated() {
							if filteredSection.key == section.key {
								filteredData[sectionIndex].data.append(friend)
								found = true
								break
							}
						}
						
						// Если такого ключа ещё нет, то создаём новый массив с нашим найденным другом
						if !found {
							searchedSection.data = [friend]
							filteredData.append(searchedSection)
						}
					}
				}
			}
			completion()
		}
	}
	
	func cancelSearch(completion: @escaping () -> Void) {
		filteredData = friends
		completion()
	}
}

// MARK: - Private methods
private extension FriendsViewModel {
	
	/// Cоздаёт массив  букв для заголовков секций
	func loadLetters() {
		for user in friends {
			lettersOfNames.append(String(user.key))
		}
	}
}
