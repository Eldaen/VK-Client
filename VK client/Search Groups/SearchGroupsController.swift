//
//  SearchGroupsController.swift
//  test-gu
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

class SearchGroupsController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var groups = GroupsLoader.iNeedGroups()
    lazy var filteredGroups = groups

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGroupsCell", for: indexPath) as? SearchGroupsCell else {
            return UITableViewCell()
        }

        let name = filteredGroups[indexPath.row].name
        let image = filteredGroups[indexPath.row].image
        
        cell.groupName.text = name
        cell.groupImage.image = UIImage(named: image)

        return cell
    }
}

extension SearchGroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // не случай повторных поисков
        filteredGroups = []
        
        // Если строка поиска пустая, то показываем все группы
        if searchText == "" {
            filteredGroups = groups
        } else {
            //По сравнению с друзьями, тут вообще всё просто. Если в именни группы есть нужный текст, то добавляем в фильтр
            for group in groups {
                if group.name.lowercased().contains(searchText.lowercased()) {
                    filteredGroups.append(group)
                }
            }
        }
        // Перезагружаем данные
        self.tableView.reloadData()

    }
}
