//
//  MyGroupsViewModel.swift
//  VK client
//
//  Created by Денис Сизов on 25.11.2021.
//

import UIKit.UIImage
import Firebase

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
	
	/// Добавляет пользователя и в Firebase и данные о группе, в которую он вступил
	func addFirebaseUser(name: String, id: Int)
	
	/// Отправляет запрос на выход из группы и если успех, то удаляет её из списка для отображения
	func leaveGroup(id: Int, index: Int, completion: @escaping (Bool) -> Void)
	
	/// Осуществляет поиск групп среди списка групп пользователя по введённому тексту
	func search(_ text: String, completion: @escaping () -> Void)
	
	/// Осуществляет действия после нажатия кнопки отмены поиска
	func cancelSearch(completion: @escaping() -> Void)
}

/// Вью модель для контроллера MyGroups
final class MyGroupsViewModel: MyGroupsViewModelType {
	var loader: GroupsLoader
	var groups: [GroupModel] = []
	var filteredGroups: [GroupModel] = []
	var ref = Database.database(url: "https://vk-client-97140-default-rtdb.europe-west1.firebasedatabase.app")
		.reference(withPath: "Users")
	
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
			self?.observe()
			completion()
		}
	}
	
	/// Создаём наблюдатель за группами в Firebase
	func observe() {
		ref.observe(.value) { snapshot in
			var groups: [FirebaseGroup] = []
			
			for child in snapshot.children {
				if let snapshot = child as? DataSnapshot,
				   let group = FirebaseGroup(snapshot: snapshot) {
					groups.append(group)
				}
			}
			
			print("Количество групп: " + String(groups.count))
		}
	}
	
	/// Добавляет в Firebase данные о пользователе и о группе, в которую он вступил
	func addFirebaseUser(name: String, id: Int) {
		guard let userId = Session.instance.userID else {
			return
		}
		let user = FirebaseUser(id: userId)
		user.groups.append(FirebaseGroup(name: name, id: id))
		
		let userRef = self.ref.child(String(userId))
		userRef.setValue(user.toFireBase)
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
		completion()
	} else {
		for group in groups {
			if group.name.lowercased().contains(text.lowercased()) {
				filteredGroups.append(group)
			}
		}
		completion()
	}
}

func cancelSearch(completion: @escaping() -> Void) {
	filteredGroups = groups
	completion()
}
}
