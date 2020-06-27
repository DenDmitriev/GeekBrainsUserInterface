//
//  GroupsTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    
    var groups: [Group] = [
        Group(title: "Новости Кино", avatar: UIImage(named: "Новости Кино")),
        Group(title: "Культура", avatar: UIImage(named: "Культура")),
        Group(title: "Мое кино", avatar: UIImage(named: "Мое кино")),
        Group(title: "Развлечения", avatar: UIImage(named: "Развлечения")),
        Group(title: "Настольные Игры", avatar: UIImage(named: "Настольные Игры")),
        Group(title: "Програмирование", avatar: UIImage(named: "Програмирование")),
        Group(title: "Досуг", avatar: UIImage(named: "Досуг")),
        Group(title: "Искусство", avatar: UIImage(named: "Искусство")),
        Group(title: "Музыка", avatar: UIImage(named: "Музыка"))
    ]
    
    var filteredGroups: [Group] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Groups"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredGroups.count : groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupTableViewCell
        let currentGroups = isFiltering ? filteredGroups : groups
        cell.set(title: currentGroups[indexPath.row].title ?? "Some Group", avatar: currentGroups[indexPath.row].avatar ?? UIImage())
        return cell
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredGroups = groups.filter { (group: Group) -> Bool in
            return group.title!.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering {
                let group = filteredGroups[indexPath.row]
                let index = groups.firstIndex { $0.title == group.title }
                groups.remove(at: index!)
                filteredGroups.remove(at: indexPath.row)
            } else {
                groups.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }


}

extension GroupsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
