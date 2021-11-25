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
}
