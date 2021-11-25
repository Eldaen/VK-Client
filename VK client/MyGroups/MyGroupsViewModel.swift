//
//  MyGroupsViewModel.swift
//  VK client
//
//  Created by Денис Сизов on 25.11.2021.
//

import UIKit.UIImage

/// Протокол Вью модели для контроллера MyGroups
protocol MyGroupsViewModelType {
	
	/// Cписок групп текущего пользователя
	var groups: [GroupModel] { get }
	
	/// Cписок групп текущего пользователя, которые подходят под поисковой запрос
	var filteredGroups: [GroupModel] { get }
	
	/// Сервис по загрузке данных групп
	var loader: GroupsLoader { get }
	
	/// Конфигурируем ячейку группы для отображения
	func configureCell(cell: MyGroupsCell, index: Int)
	
	/// Скачиваем из сети список групп пользователя
	func fetchGroups(completion: @escaping () -> Void)
	
	/// Отправляет запрос на выход из группы и если успех, то удаляет её из списка для отображения
	func leaveGroup(id: Int, index: Int, completion: @escaping (Bool) -> Void)
	
	/// Осуществляет поиск групп среди списка групп пользователя по введённому тексту
	func search(_ text: String, completion: @escaping () -> Void)
}

class MyGroupsViewModel: MyGroupsViewModelType {
	var loader: GroupsLoader
	var groups: [GroupModel] = []
	var filteredGroups: [GroupModel] = []
	
	init(loader: GroupsLoader){
		self.loader = loader
	}
	
	func configureCell(cell: MyGroupsCell, index: Int) {
		let name = filteredGroups[index].name
		let image = filteredGroups[index].image
		let id = filteredGroups[index].id
		
		cell.configure(name: name, image: UIImage(), id: id)
		
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
	
	func leaveGroup(id: Int, index: Int, completion: @escaping (Bool) -> Void) {
		loader.leaveGroup(id: id) { [weak self] result in
			DispatchQueue.main.async {
				if result == 1 {
					self?.groups.remove(at: index)
					self?.filteredGroups.remove(at: index)
					completion(true)
				} else {
					completion(false)
				}
			}
		}
	}
	
	func search(_ text: String, completion: @escaping () -> Void) {
		filteredGroups = []

		// Если строка поиска пустая, то показываем все группы
		if text == "" {
			filteredGroups = groups
		} else {
			for group in groups {
				if group.name.lowercased().contains(text.lowercased()) {
					filteredGroups.append(group)
				}
			}
			completion()
		}
	}
}
