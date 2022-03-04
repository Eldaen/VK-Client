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
	}
}
