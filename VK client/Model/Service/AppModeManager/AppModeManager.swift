//
//  AppModeManager.swift
//  VK client
//
//  Created by Денис Сизов on 04.03.2022.
//

import UIKit

protocol ModeManagerProtocol {
	func setDemoMode(_ mode: Bool, nextController controller: UITabBarController)
}

/// Конфигурирует режим работы приложения, с реальным API или в ДЕМО режим
final class AppModeManager {
	
	// MARK: - Private methods
	
	private func createNavController(for rootViewController: UIViewController,
									 title: String,
									 image: UIImage) -> UIViewController {
		let navController = UINavigationController(rootViewController: rootViewController)
		navController.tabBarItem.title = title
		navController.tabBarItem.image = image
		rootViewController.navigationItem.title = title
		navController.navigationBar.tintColor = .black
		return navController
	}
	
	private func configureVC(_ controller: UITabBarController) {
		let groupsVM = Assembly.instance.myGroupsViewModel
		let friendsVM = Assembly.instance.friendsViewModel
		let newsVM = Assembly.instance.newsViewModel
		
		let myGroups = createNavController(for: MyGroupsController(
			model: groupsVM),
								  title: "Мои группы", image: UIImage(systemName: "person.3")!)
		
		let friends = createNavController(for: FriendsViewController(
			model: friendsVM),
								  title: "Друзья", image: UIImage(systemName: "person")!)
		
		let news = createNavController(for: NewsController(
			model: newsVM),
										  title: "Новости", image: UIImage(systemName: "newspaper")!)
		
		controller.viewControllers = [myGroups, friends, news]
	}
}

extension AppModeManager: ModeManagerProtocol {
	
	/// Устанавливает режим работы приложения. True - демо режим, False - работа с API
	public func setDemoMode(_ mode: Bool, nextController controller: UITabBarController) {
		Assembly.instance.setDemoMode(mode)
		configureVC(controller)
	}
}
