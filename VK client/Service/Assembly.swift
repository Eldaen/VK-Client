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
	
	var networkManager: NetworkManager
	var cacheService: ImageCache
	
	var userService: UserLoader
	var groupsService: GroupsLoader
	
//	var userService: UserLoader = {
//		if demoMode == false {
//			return UserService(networkManager: networkManager, cache: cacheService)
//		} else {
//			return demoUserService(networkManager: networkManager, cache: cacheService)
//		}
//	}()
//
//	var groupsService: GroupsLoader = {
//		if demoMode == false {
//			return GroupsService(networkManager: networkManager, cache: cacheService)
//		} else {
//			return demoGroupService(networkManager: networkManager, cache: cacheService)
//		}
//	}()
	
	lazy var myGroupsViewModel: MyGroupsViewModelType = MyGroupsViewModel(loader: groupsService)
	lazy var searchGroupsViewModel: SearchGroupsViewModelType = SearchGroupsViewModel(loader: groupsService)
	lazy var friendsViewModel: FriendsViewModelType = FriendsViewModel(loader: userService)
	
	// Вот тут у нас только тип, т.к. там через инициализаторы передаются данные при переходе
	var friendProfileViewModel: FriendsProfileViewModelType.Type = FriendsProfileViewModel.self
	var galleryViewModel: GalleryType.Type = GalleryViewModel.self
	
	///  Инстанс синглтона Assembly
	static let instance = Assembly()
	
	private init() {
		let cache = ImageCacheService()
		self.cacheService = cache
		
		let network = NetworkManager()
		self.networkManager = network
		
		self.userService = UserService(networkManager: network, cache: cache)
		self.groupsService = GroupsService(networkManager: network, cache: cache)
	}
	
	/// Возможность включить Демо режим
	func setDemoMode(_ state: Bool) {
		self.demoMode = state
		
		if demoMode == true {
			userService = demoUserService(networkManager: networkManager, cache: cacheService)
			groupsService = demoGroupService(networkManager: networkManager, cache: cacheService)
		} else {
			userService = UserService(networkManager: networkManager, cache: cacheService)
			groupsService = GroupsService(networkManager: networkManager, cache: cacheService)
		}
	}
	
	/// Возможность включить Демо режим
	func getDemoMode() -> Bool {
		self.demoMode
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
