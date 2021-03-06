//
//  Assembly.swift
//  VK client
//
//  Created by Денис Сизов on 26.11.2021.
//

import UIKit

/// Сборщик зависимостей, ничего лучше синглтона не придумал
/// Можно сделать чтение этого всего из конфига
final class Assembly {
	private var demoMode: Bool = false
	
	var networkManager: NetworkManager
	var cacheService: ImageCache
	var persistence: PersistenceManager
	var networkProxy: NetworkLoggingProxy
	
	var userService: UserLoader
	var groupsService: GroupsLoader
	var newsService: NewsLoader
	
	var myGroupsViewModel: MyGroupsViewModelType
	var searchGroupsViewModel: SearchGroupsViewModelType
	var friendsViewModel: FriendsViewModelType
	var newsViewModel: NewsViewModelType
	
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
		
		let proxy = NetworkLoggingProxy(networkManager: network)
		self.networkProxy = proxy
		
		let persistence = RealmService()
		self.persistence = persistence
		
		let userService = UserService(networkManager: proxy, cache: cache, persistence: persistence)
		self.userService = userService
		
		let groupsService = GroupsService(networkManager: proxy, cache: cache, persistence: persistence)
		self.groupsService = groupsService
		
		let newsService = NewsService(networkManager: proxy, cache: cache, persistence: persistence)
		self.newsService = newsService
		
		self.myGroupsViewModel = MyGroupsViewModel(loader: groupsService)
		self.searchGroupsViewModel = SearchGroupsViewModel(loader: groupsService)
		self.friendsViewModel = FriendsViewModel(loader: userService)
		self.newsViewModel = NewsViewModel(loader: newsService)
	}
	
	/// Возможность включить Демо режим
	func setDemoMode(_ state: Bool) {
		self.demoMode = state
		
		if demoMode == true {
			userService = demoUserService(networkManager: networkManager, cache: cacheService, persistence: persistence)
			groupsService = demoGroupService(networkManager: networkManager, cache: cacheService, persistence: persistence)
			newsService = demoNewsServiceReal(networkManager: networkManager, cache: cacheService, persistence: persistence)
		} else {
			userService = UserService(networkManager: networkProxy, cache: cacheService, persistence: persistence)
			groupsService = GroupsService(networkManager: networkProxy, cache: cacheService, persistence: persistence)
			newsService = NewsService(networkManager: networkProxy, cache: cacheService, persistence: persistence)
		}
		
		myGroupsViewModel = MyGroupsViewModel(loader: groupsService)
		searchGroupsViewModel = SearchGroupsViewModel(loader: groupsService)
		friendsViewModel = FriendsViewModel(loader: userService)
		newsViewModel = NewsViewModel(loader: newsService)
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
	func getGalleryViewModel(loader: UserLoader, selectedPhoto: Int, images: [ApiImage]) -> GalleryType {
		return GalleryViewModel(loader: loader, selectedPhoto: selectedPhoto, images: images)
	}
}
