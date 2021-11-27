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
		
		let myGroups = createNavController(for: MyGroupsController(
			model: Assembly.instance.myGroupsViewModel),
								  title: "Мои группы", image: UIImage(systemName: "person.3")!)
		
		let friends = createNavController(for: FriendsViewController(
			model: Assembly.instance.friendsViewModel),
								  title: "Друзья", image: UIImage(systemName: "person")!)
		
		let news = createNavController(for: NewsController(model: NewsViewModel()),
										  title: "Новости", image: UIImage(systemName: "newspaper")!)
		
		viewControllers = [myGroups, friends, news]
	}
	
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
}
