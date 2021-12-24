//
//  LinkView.swift
//  VK client
//
//  Created by Денис Сизов on 24.12.2021.
//

import UIKit

class LinkView: UICollectionReusableView {
	
	var label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.font = UIFont.preferredFont(forTextStyle: .subheadline)
		label.text = "SomeLink"
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .lightGray
		layer.cornerRadius = 5
		layer.shadowRadius = 0.5
		
		addSubview(label)
		
		NSLayoutConstraint.activate([
			label.centerYAnchor.constraint(equalTo: centerYAnchor),
			label.centerXAnchor.constraint(equalTo: centerXAnchor),
			heightAnchor.constraint(equalToConstant: 25),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
