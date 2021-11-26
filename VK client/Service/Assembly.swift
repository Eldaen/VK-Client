//
//  Assembly.swift
//  VK client
//
//  Created by Денис Сизов on 26.11.2021.
//

import UIKit

/// Конфиг зависимостей, ничего лучше синглтона не придумал
/// Можно сделать чтение этого всего из конфига
final class Assembly {
	private var demoMode: Bool = false
	
	lazy var networkManager: NetworkManager = NetworkManager()
	lazy var cacheService: ImageCache = ImageCacheService()
	
	// TODO: - Заменить на демо модели в блоке else
	lazy var userService: UserLoader = {
		if demoMode == false {
			return UserService(networkManager: networkManager, cache: cacheService)
		} else {
			return UserService(networkManager: networkManager, cache: cacheService)
		}
	}()
	
	// TODO: - Заменить на демо модели в блоке else
	lazy var groupsService: GroupsLoader = {
		if demoMode == false {
			return GroupsService(networkManager: networkManager, cache: cacheService)
		} else {
			return GroupsService(networkManager: networkManager, cache: cacheService)
		}
	}()
	
	lazy var myGroupsViewModel: MyGroupsViewModelType = MyGroupsViewModel(loader: groupsService)
	lazy var searchGroupsViewModel: SearchGroupsViewModelType = SearchGroupsViewModel(loader: groupsService)
	lazy var friendsViewModel: FriendsViewModelType = FriendsViewModel(loader: userService)
	
	// Вот тут у нас только тип, т.к. там через инициализаторы передаются данные при переходе
	var friendProfileViewModel: FriendsProfileViewModelType.Type = FriendsProfileViewModel.self
	var galleryViewModel: GalleryType.Type = GalleryViewModel.self
	
	///  Инстанс синглтона Assembly
	static let instance = Assembly()
	
	private init() {}
	
	/// Возможность включить Демо режим
	func setDemoMode(_ state: Bool) {
		self.demoMode = state
	}
	
	/// геттер для класса переменной friendProfileViewModel
	func getFriendProfileViewModel(
		friend: UserModel,
		loader: UserLoader,
		profileImage: UIImage
	) -> FriendsProfileViewModelType {
		return friendProfileViewModel.init(friend: friend, loader: loader, profileImage: profileImage)
	}
	
	/// геттер для класса переменной galleryViewModel
	func getGalleryViewModel(loader: UserLoader, selectedPhoto: Int, images: [UserImages]) -> GalleryType {
		return GalleryViewModel(loader: loader, selectedPhoto: selectedPhoto, images: images)
	}
}
