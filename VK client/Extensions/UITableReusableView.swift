//
//  UITableReusableView.swift
//  VK client
//
//  Created by Денис Сизов on 24.12.2021.
//

import UIKit

extension UITableViewCell {
	@objc static var reuseIdentifier: String {
		return String(describing: Self.self)
	}
}
