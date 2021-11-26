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
	lazy var networkManager: NetworkManager = NetworkManager()
	lazy var cacheService: ImageCache = ImageCacheService()
	
	lazy var userService: UserLoader = UserService(networkManager: networkManager, cache: cacheService)
	lazy var groupsService: GroupsLoader = GroupsService(networkManager: networkManager, cache: cacheService)
	
	lazy var myGroupsViewModel: MyGroupsViewModelType = MyGroupsViewModel(loader: groupsService)
	lazy var searchGroupsViewModel: SearchGroupsViewModelType = SearchGroupsViewModel(loader: groupsService)
	lazy var friendsViewModel: FriendsViewModelType = FriendsViewModel(loader: userService)
	
	// Вот тут у нас только тип, т.к. там через инициализаторы передаются данные при переходе
	var friendProfileViewModel: FriendsProfileViewModelType.Type = FriendsProfileViewModel.self
	var galleryViewModel: GalleryType.Type = GalleryViewModel.self
	
	///  Инстанс синглтона Assembly
	static let instance = Assembly()
	
	private init() {}
	
	func getFriendProfileViewModel(
		friend: UserModel,
		loader: UserLoader,
		profileImage: UIImage
	) -> FriendsProfileViewModelType {
		return friendProfileViewModel.init(friend: friend, loader: loader, profileImage: profileImage)
	}
	
	func getGalleryViewModel(loader: UserLoader, selectedPhoto: Int, images: [UserImages]) -> GalleryType {
		return GalleryViewModel(loader: loader, selectedPhoto: selectedPhoto, images: images)
	}
}
