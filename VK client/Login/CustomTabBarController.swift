//
//  CustomTabBarController.swift
//  VK client
//
//  Created by Денис Сизов on 05.11.2021.
//

import UIKit

class CustomTabBarController: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		let controllerArray = [MyGroupsController()]
		viewControllers = controllerArray.map{ UINavigationController.init(rootViewController: $0)}

		self.tabBar.tintColor = .black
	}

}
