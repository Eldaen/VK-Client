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
		let groupsController = MyGroupsController()
		
		// Параметры отображения
		self.view.tintColor = .black

		viewControllers = [groupsController]
	}

}
