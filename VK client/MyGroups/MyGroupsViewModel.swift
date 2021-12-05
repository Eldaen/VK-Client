//
//  MyGroupsViewModel.swift
//  VK client
//
//  Created by Денис Сизов on 25.11.2021.
//

import UIKit.UIImage
import RealmSwift

/// Протокол Вью модели для контроллера MyGroups
protocol MyGroupsViewModelType {
	
	/// Cписок групп текущего пользователя
	var groups: Results<GroupModel>? { get }
	
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
	
	/// Осуществляет действия после нажатия кнопки отмены поиска
	func cancelSearch(completion: @escaping() -> Void)
}

/// Вью модель для контроллера MyGroups
final class MyGroupsViewModel: MyGroupsViewModelType {
	var groups: Results<GroupModel>?
	
	var loader: GroupsLoader
	//var groups: [GroupModel] = []
	var filteredGroups: [GroupModel] = []
	
	private let realm = RealmService()
	
	init(loader: GroupsLoader){
		self.loader = loader
	}
	
	func configureCell(cell: MyGroupsCell, index: Int) {
		let name = groups?[index].name
		let image = groups?[index].image
		let id = groups?[index].id
		
		cell.configure(name: name ?? "", image: UIImage(), id: id ?? 0)
		
		loader.loadImage(url: image ?? "") { image in
			cell.setImage(with: image)
		}
	}
	
	func fetchGroups(completion: @escaping () -> Void) {
		realm.read(GroupModel.self) { [weak self] result in
			self?.groups = result
		}
		completion()
	}
	
	func leaveGroup(id: Int, index: Int, completion: @escaping (Bool) -> Void) {
		loader.leaveGroup(id: id) { [weak self] result in
			self?.realm.delete(GroupModel.self, keyValue: String(id) ) { _ in }
		}
	}

	func search(_ text: String, completion: @escaping () -> Void) {		filteredGroups = []
		
		// Если строка поиска пустая, то показываем все группы
		if text == "" {
			fetchGroups { }
		} else {
			groups = realm.realm.objects(GroupModel.self).filter("name CONTAINS %@", "\(text.lowercased())")
			completion()
		}
	}

	func cancelSearch(completion: @escaping() -> Void) {
		//filteredGroups = groups
		completion()
	}
}
