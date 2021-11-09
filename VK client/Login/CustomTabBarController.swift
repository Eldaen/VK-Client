//
//  CustomTabBarController.swift
//  VK-Client
//
//  Created by Денис Сизов on 05.11.2021.
//

import UIKit

final class CustomTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tabBar.tintColor = .black
		self.tabBar.barTintColor = .white
		self.tabBar.unselectedItemTintColor = .gray
		self.tabBar.backgroundColor = .white
		setupVCs()
	}
	
	/// Cоздаём и конфигурируем Navigation Контроллеры, которые будут отображены в табах
	private func setupVCs() {
		viewControllers = [
			createNavController(for: MyGroupsController(), title: "Мои группы", image: UIImage(systemName: "person.3")!),
			createNavController(for: FriendsViewController(), title: "Друзья", image: UIImage(systemName: "person")!),
			createNavController(for: NewsController(), title: "Новости", image: UIImage(systemName: "newspaper")!),
		]
	}
	
	private func createNavController(for rootViewController: UIViewController,
									 title: String,
									 image: UIImage) -> UIViewController {
		let navController = UINavigationController(rootViewController: rootViewController)
		navController.tabBarItem.title = title
		navController.tabBarItem.image = image
		rootViewController.navigationItem.title = title
		return navController
	}
}
