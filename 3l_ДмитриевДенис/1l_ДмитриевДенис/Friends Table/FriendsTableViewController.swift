//
//  FriendsTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    var friends = [
        User(name: "Бен Кингсли", avatar: UIImage(named: "Бен Кингсли")),
        User(name: "Бенедикт Харди", avatar: UIImage(named: "Бенедикт Харди")),
        User(name: "Брайан Браун", avatar: UIImage(named: "Брайан Браун")),
        User(name: "Джек Томпсон", avatar: UIImage(named: "Джек Томпсон")),
        User(name: "Дженнифер Коннелли", avatar: UIImage(named: "Дженнифер Коннелли")),
        User(name: "Майкл Фассбендер", avatar: UIImage(named: "Майкл Фассбендер")),
        User(name: "Марион Котийяр", avatar: UIImage(named: "Марион Котийяр")),
        User(name: "Рэйчел Вайс", avatar: UIImage(named: "Рэйчел Вайс")),
        User(name: "Эмили Барклай", avatar: UIImage(named: "Эмили Барклай"))
    ]
    
    var filteredFriends: [User] = []
    
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
        searchController.searchBar.placeholder = "Search Friend"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isFiltering ? filteredFriends.count : friends.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendTableViewCell
        let currentFriends = isFiltering ? filteredFriends : friends
        cell.set(name: currentFriends[indexPath.row].name ?? "Name", avatar: currentFriends[indexPath.row].avatar ?? UIImage())
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering {
                let friend = filteredFriends[indexPath.row]
                let index = friends.firstIndex { $0.name == friend.name }
                friends.remove(at: index!)
                filteredFriends.remove(at: indexPath.row)
            } else {
                friends.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let collectionView = segue.destination as? PhotosFriendCollectionViewController else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        let currentFriends = isFiltering ? filteredFriends : friends
        collectionView.photos = [currentFriends[indexPath.row].avatar ?? UIImage()]
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFriends = friends.filter { (friend: User) -> Bool in
            return friend.name!.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

}

extension FriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
