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
		let vc1 = UINavigationController(rootViewController: LoginController())

		viewControllers = [vc1]
	}

}
