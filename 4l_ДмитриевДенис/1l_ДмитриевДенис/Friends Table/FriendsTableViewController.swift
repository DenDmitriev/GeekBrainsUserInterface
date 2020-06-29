//
//  FriendsTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class FriendsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var alphabet: [String] = []

    
    var friends = [
        User(name: "Бен Кингсли", avatar: UIImage(named: "Бен Кингсли")),
        User(name: "Бенедикт Харди", avatar: UIImage(named: "Бенедикт Харди")),
        User(name: "Брайан Браун", avatar: UIImage(named: "Брайан Браун")),
        User(name: "Джек Томпсон", avatar: UIImage(named: "Джек Томпсон")),
        User(name: "Дженнифер Коннелли", avatar: UIImage(named: "Дженнифер Коннелли")),
        User(name: "Майкл Фассбендер", avatar: UIImage(named: "Майкл Фассбендер")),
        User(name: "Марион Котийяр", avatar: UIImage(named: "Марион Котийяр")),
        User(name: "Рэйчел Вайс", avatar: UIImage(named: "Рэйчел Вайс")),
        User(name: "Эмили Барклай", avatar: UIImage(named: "Эмили Барклай")),
        User(name: "Донал Глисон", avatar: UIImage(named: "Донал Глисон")),
        User(name: "Лидия Уилсон", avatar: UIImage(named: "Лидия Уилсон")),
        User(name: "Линдси Дункан", avatar: UIImage(named: "Линдси Дункан")),
        User(name: "Марго Робби", avatar: UIImage(named: "Марго Робби")),
        User(name: "Митчелл Маллен", avatar: UIImage(named: "Митчелл Маллен")),
        User(name: "Рене Зеллвегер", avatar: UIImage(named: "Рене Зеллвегер")),
        User(name: "Рэйчел МакАдамс", avatar: UIImage(named: "Рэйчел МакАдамс")),
        User(name: "Том Холландер", avatar: UIImage(named: "Том Холландер")),
        User(name: "Уилл Меррик", avatar: UIImage(named: "Уилл Меррик"))
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    var filteredFriends: [User] = []
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var filterChar: FilterControl!
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for friend in friends {
            let char = String(friend.name!.prefix(1))
            if !alphabet.contains(char) {
                alphabet.append(char)
            }
        }
        
        filterChar.alphabet = alphabet
        filterChar.update()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Friend"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @IBAction func filterAlphabetTap(_ sender: FilterControl) {
        print(#function)
        let char = sender.char!
        let section = alphabet.firstIndex(of: char)!
        let indexPath = IndexPath(item: 0, section: section)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return alphabet.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alphabet[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == alphabet.firstIndex(of: alphabet[section]) {
            let currentFriends = isFiltering ? filteredFriends : friends
            let sectionFriends = currentFriends.filter { (friend: User) -> Bool in
                return friend.name!.lowercased().prefix(1).contains(alphabet[section].lowercased()) }
            return sectionFriends.count
        } else {
            return 0
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendTableViewCell
        let currentFriends = isFiltering ? filteredFriends : friends
        let sectionFriends = currentFriends.filter { (friend: User) -> Bool in
            return friend.name!.lowercased().prefix(1).contains(alphabet[indexPath.section].lowercased()) }
        cell.set(name: sectionFriends[indexPath.row].name ?? "Name", avatar: sectionFriends[indexPath.row].avatar ?? UIImage())
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let collectionView = segue.destination as? PhotosFriendCollectionViewController else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        let cell = tableView.cellForRow(at: indexPath) as! FriendTableViewCell
        collectionView.photos = [cell.avatarImage?.image ?? UIImage()]
    }
    
    // MARK: - Filter
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
