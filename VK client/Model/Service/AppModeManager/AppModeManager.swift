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
	
	/// Делегат для перезапуска приложения
	weak var restartDelegate: RestartDelegate?
	
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
		
		let myGroupsVC = MyGroupsController(model: groupsVM)
		myGroupsVC.restartDelegate = restartDelegate
		let myGroups = createNavController(for: myGroupsVC,
								  title: "Мои группы", image: UIImage(systemName: "person.3")!)
		
		let friendsVC = FriendsViewController(model: friendsVM)
		friendsVC.restartDelegate = restartDelegate
		let friends = createNavController(for: friendsVC,
								  title: "Друзья", image: UIImage(systemName: "person")!)
		
		let newsVC = NewsController(model: newsVM)
		newsVC.restartDelegate = restartDelegate
		let news = createNavController(for: newsVC,
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
