//
//  Assembly.swift
//  VK client
//
//  Created by Денис Сизов on 26.11.2021.
//

/// Конфиг зависимостей, ничего лучше синглтона не придумал
/// Можно сделать чтение этого всего из конфига, можно сделать создание объектов по мере надобности
/// Пока буду создавать объекты на месте из типа
final class Assembly {
	lazy var networkManager: NetworkManager = NetworkManager()
	lazy var cacheService: ImageCache = ImageCacheService()
	
	lazy var userService: UserLoader = UserService(networkManager: networkManager, cache: cacheService)
	lazy var groupsService: GroupsLoader = GroupsService(networkManager: networkManager, cache: cacheService)
	
	lazy var myGroupsViewModel: MyGroupsViewModelType = MyGroupsViewModel(loader: groupsService)
	lazy var searchGroupsViewModel: SearchGroupsViewModelType = SearchGroupsViewModel(loader: groupsService)
	lazy var friendsViewModel: FriendsViewModelType = FriendsViewModel(loader: userService)
	
	lazy var friendProfileViewModel: FriendsProfileViewModelType.Type = FriendsProfileViewModel.self
	lazy var galleryViewModel: GalleryType.Type = GalleryViewModel.self
	
	///  Инстанс синглтона Assembly
	static let instance = Assembly()
	
	private init() {}
}
