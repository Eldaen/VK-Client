//
//  NewsController.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

class NewsController: UITableViewController {
    
    let news = NewsLoader.iNeedNews()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // динамический размер ячейки, но может это и не надо
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        // чтобы дырки не было между ячейками
        tableView.sectionHeaderTopPadding = 0
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return news.count // одна секция - одна новость
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    // отрисовываем ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        // конфигурируем ячейку
        cell.configure(with: news[indexPath.section])
        
        return cell
    }
    
    // Добавляем футер с лайк контролом
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //Создаём кастомную вьюху заголовка
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        let likeControl = LikeControl(frame: CGRect(x: 5, y: 0, width: 50, height: 20))
        likeControl.tintColor = .red
        
        let views = UILabel(frame: CGRect(x: footer.frame.size.width - 50, y: 0, width: 50, height: 20))
        views.text = "42"
        views.font = UIFont.systemFont(ofSize: 18)
        
        footer.addSubview(likeControl)
        footer.addSubview(views)
        
        return footer
    }
    
    // добавляем заголовок, чтобы визуально разграничить новости
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Создаём кастомную вьюху заголовка
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        header.backgroundColor = .gray
        
        return header
    }
    
    // правим высоту хидера со стандартной до нужной
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        5.0
    }
}


