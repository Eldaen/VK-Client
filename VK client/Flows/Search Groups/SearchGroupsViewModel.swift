//
//  SearchGroupsViewModel.swift
//  VK client
//
//  Created by Денис Сизов on 25.11.2021.
//

import UIKit.UIImage

/// Протокол вью модели для SearchGroups контроллера
protocol SearchGroupsViewModelType {
	
	/// Все группы, которые нам передал загрузчик
	var groups: [GroupModel] { get }
	
	/// Cписок групп, которые подходят под поисковой запрос
	var filteredGroups: [GroupModel] { get }
	
	/// Сервис по загрузке данных групп
	var loader: GroupsLoader { get }
	
	/// Конфигурируем ячейку группы для отображения
	func configureCell(cell: SearchGroupsCell, index: Int)
	
	/// Скачиваем из сети список групп
	func fetchGroups(completion: @escaping () -> Void)
	
	/// Отправляет запрос на вступление в группу
	func joinGroup(id: Int, index: Int, completion: @escaping (Bool) -> Void)
	
	/// Осуществляет поиск групп среди списка групп  по введённому тексту
	func search(_ text: String, completion: @escaping () -> Void)
	
	/// Осуществляет действия после нажатия кнопки отмены поиска
	func cancelSearch(completion: @escaping() -> Void)
}

/// Вью модель для контроллера SearchGroups
final class SearchGroupsViewModel: SearchGroupsViewModelType {
	var groups: [GroupModel] = []
	var filteredGroups: [GroupModel] = []
	var loader: GroupsLoader
	
	init(loader: GroupsLoader) {
		self.loader = loader
	}
	
	func configureCell(cell: SearchGroupsCell, index: Int) {
		let name = filteredGroups[index].name
		let image = filteredGroups[index].image
		let id = filteredGroups[index].id
		let isMember = filteredGroups[index].isMember
		
		//Конфигурируем и возвращаем готовую ячейку
		cell.configure(name: name, image: UIImage(), id: id, isMember: isMember)
		
		// Ставим картинку на загрузку
		loader.loadImage(url: image) { image in
			cell.setImage(with: image)
		}
	}
	
	func fetchGroups(completion: @escaping () -> Void) {
		loader.loadGroups() { [weak self] groups in
			self?.groups = groups
			self?.filteredGroups = groups
			completion()
		}
	}
	
	// TODO: - Разделить здесь ошибки ответа сервера и факта, что уже вступил в эту группу
	func joinGroup(id: Int, index: Int, completion: @escaping (Bool) -> Void) {
		let cell = filteredGroups[index]
		
		if cell.isMember != 1 {
			loader.joinGroup(id: id) { result in
				if result == 1 { // 1 это если получилось вступить
					completion(true)
				} else {
					completion(false)
				}
			}
		} else {
			completion(false)
		}
	}
	
	func search(_ text: String, completion: @escaping () -> Void) {
		
		// не случай повторных поисков
		filteredGroups = []
		
		var query = text
		
		// Если отправить запрос с пустой строкой поиска, то оно не будет искать, так что ищем с пробелом
		if query == "" {
			query = " "
		}
		
		loader.searchGroups(with: query) { [weak self] groups in
			DispatchQueue.main.async {
				self?.groups = groups
				self?.filteredGroups = groups
				completion()
			}
		}
	}
	
	func cancelSearch(completion: @escaping() -> Void) {
		filteredGroups = groups
		completion()
	}
}
