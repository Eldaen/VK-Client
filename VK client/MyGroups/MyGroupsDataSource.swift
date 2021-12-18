//
//  MyGroupsDataSource.swift
//  VK client
//
//  Created by Денис Сизов on 17.12.2021.
//

import UIKit

class MyGroupsDataSource: UITableViewDiffableDataSource<Int, GroupModel> {
	
	var viewModel: MyGroupsViewModelType?
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
	  return true
	}
	
	override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			guard let cell = tableView.cellForRow(at: indexPath) as? MyGroupsCell,
				  let id = cell.id,
				  let model = viewModel?.filteredGroups[indexPath.item] else {
					  return
				  }
			
			viewModel?.leaveGroup(id: id, index: indexPath.row) { [weak self] _ in
				if var snapshot = self?.snapshot() {
					snapshot.deleteItems([model])
					self?.apply(snapshot)
				}
			}
		}
	}
}
