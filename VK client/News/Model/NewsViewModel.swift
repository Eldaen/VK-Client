//
//  NewsViewModel.swift
//  VK client
//
//  Created by Денис Сизов on 25.11.2021.
//

/// Протокол ViewModel для контроллера новостей
protocol NewsViewModelType {
	var news: [NewsTableViewCellModel] { get }
	
	/// Конфигурирует ячейку новости данными, которые получили из сервиса
	func configureCell(cell: NewsTableViewCell, index: Int)
}

/// ВьюМодель новости, заполняет ячейки данными и получает их от менеджера
final class NewsViewModel: NewsViewModelType {
	var news: [NewsTableViewCellModel] = NewsService.iNeedNews()
	
	func configureCell(cell: NewsTableViewCell, index: Int) {
		cell.configure(with: news[index])
	}
}
