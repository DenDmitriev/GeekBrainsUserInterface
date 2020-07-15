//
//  GlobalGroupsTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import LoremIpsum

class GlobalGroupsTableViewController: UITableViewController {
    
    let loading = LoadingCloudView()
    
    var groups: [Group] = []
    
    
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
        searchController.searchBar.placeholder = "Search Global Groups"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loading.frame = tableView.frame
        tableView.addSubview(loading)
        loading.beginLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if groups.isEmpty {
            refresh()
        } else {
            loading.endLoad()
            loading.removeFromSuperview()
        }
    }
    
    //MARK: - Data loading
    
    @objc func refresh() {
        print(#function)
        groups = loadGroupData(amount: 10)
        tableView.reloadData()
        loading.endLoad()
        loading.removeFromSuperview()
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

extension GlobalGroupsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
