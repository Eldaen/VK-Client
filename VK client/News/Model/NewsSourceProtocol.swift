//
//  NewsSourceProtocol.swift
//  VK client
//
//  Created by Денис Сизов on 09.12.2021.
//

/// Протокол, описывающий создателя новости
protocol NewsSourceProtocol {
	var name: String { get set }
	var image: String { get set }
	var id: Int { get set }
}
