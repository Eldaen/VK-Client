//
//  MyGroupsController.swift
//  test-gu
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

class MyGroupsController: UITableViewController {
    
    var myGroups = [GroupModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as? MyGroupsCell else {
            return UITableViewCell()
        }

        let name = myGroups[indexPath.row].name
        let image = myGroups[indexPath.row].image
        
        //Конфигурируем и возвращаем готовую ячейку
        cell.configure(name: name, image: UIImage(named: image))

        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }



    // MARK: - Navigation
     
    // Это метод, который принимает unwind seague из SearchGroups при клике на группу
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Проверяем идентификатор, чтобы убедиться, что это нужный переход
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            guard let searchGroupsController = segue.source as? SearchGroupsController else {
                return
            }
            
            // Получаем название группы + Картинку и кладём в myGroups для последующей отрисовки
            if let indexPath = searchGroupsController.tableView.indexPathForSelectedRow {
                let group = searchGroupsController.groups[indexPath.row]
                
                // Если такой группы ещё нет, то добавляем
                if !myGroups.contains(group) {
                    myGroups.append(group)
                    tableView.reloadData()
                }
            }
        }
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
