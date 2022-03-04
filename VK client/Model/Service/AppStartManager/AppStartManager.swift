//
//  AppStartManager.swift
//  VK client
//
//  Created by Денис Сизов on 04.03.2022.
//

import UIKit

protocol RestartDelegate: AnyObject {
	func restart()
}

/// Сборщик первоначального запуска приложения
final class AppStartManager {
	
	var window: UIWindow?
	
	init(window: UIWindow?) {
		self.window = window
	}
	
	func start() {
		let tabBarController = CustomTabBarController()
		let appModeManager = AppModeManager()
		appModeManager.restartDelegate = self
		
		let loginController = VKLoginController(nextController: tabBarController, appModeManager: appModeManager)
		let navigationController = UINavigationController(rootViewController: loginController)
		
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
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

extension AppStartManager: RestartDelegate {
	func restart() {
		if Assembly.instance.getDemoMode() == true {
			Assembly.instance.setDemoMode(false)
		}
		
		Session.instance.clean()
		start()
	}
}
