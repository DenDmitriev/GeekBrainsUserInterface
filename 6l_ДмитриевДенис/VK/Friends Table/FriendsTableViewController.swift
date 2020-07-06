//
//  FriendsTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import LoremIpsum


class FriendsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterControlDelegate {
    
    let dataRefreshControl = UIRefreshControl()
    
    var alphabet: [String] = []
    var allPhotos: [UIImage] = []
    
    var friends: [User] = []
    
    var listFriends: [String: [User]] = [:]
    
    var currentChar: String?
    
    //Search
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFriends: [User] = []
    
    @IBOutlet weak var filterChar: FilterControl!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataRefreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.refreshControl = dataRefreshControl
        
        filterChar.delegate = self
        
        filterChar.isHidden = true

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Friend"
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataRefreshControl.beginRefreshing()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if friends.isEmpty {
            refresh(sender: dataRefreshControl)
        } else {
            dataRefreshControl.endRefreshing()
        }
        navigationItem.searchController = searchController
    }
    
    //MARK: - Data loading
    
    @objc func refresh(sender: UIRefreshControl) {
        print(#function)
        friends = loadUsersData(amount: 30)
        
        alphabetSet()
        alphabetControlSet()
        let height = tableView.frame.height/33
        filterChar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterChar.heightAnchor.constraint(equalToConstant: CGFloat(alphabet.count) * height)
        ])
        filterChar.isHidden = false
        
        for friend in friends {
            allPhotos.append(friend.avatar.first!!)
        }
        
        createListFriends()
        
        tableView.reloadData()
        
        sender.endRefreshing()
    }
    
    
    
    //MARK: - Setup list friends
    
    func alphabetSet() {
        let currentFriends = isFiltering ? filteredFriends : friends
        alphabet = []
        var letters: [String] = []
        for friend in currentFriends {
            let char = String(friend.name!.prefix(1))
            if !letters.contains(char) {
                letters.append(char.uppercased())
            }
        }
        alphabet = letters.sorted()
    }
    
    func alphabetControlSet() {
        filterChar.alphabet = alphabet
        filterChar.update()
    }
    
    func createListFriends() {
        listFriends = [:]
        let currentFriends = isFiltering ? filteredFriends : friends
        for char in alphabet {
            let sectionFriends = currentFriends.filter { (friend: User) -> Bool in
            return friend.name!.lowercased().prefix(1).contains(char.lowercased()) }
            listFriends[char] = sectionFriends
        }
    }
    
    
    //MARK: - Move table to gesture char
    
    func gestutePan(char: String) {
        guard char != currentChar else { return }
        print(char)
        let section = alphabet.firstIndex(of: char)!
        let indexPath = IndexPath(item: 0, section: section)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        currentChar = char
    }
    
    
    

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = tableView.frame.width
        let height: CGFloat = 33
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        //view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: height, height: height))
        label.text = alphabet[section]
        label.tintColor = .gray
        
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return alphabet.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return alphabet[section]
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == alphabet.firstIndex(of: alphabet[section]) {
//            let currentFriends = isFiltering ? filteredFriends : friends
//            let sectionFriends = currentFriends.filter { (friend: User) -> Bool in
//                return friend.name!.lowercased().prefix(1).contains(alphabet[section].lowercased()) }
//            return sectionFriends.count
//        } else {
//            return 0
//        }
        if section == alphabet.firstIndex(of: alphabet[section]) {
            let sectionFriends = listFriends[alphabet[section]]
            return sectionFriends?.count ?? 0
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendTableViewCell
//        let currentFriends = isFiltering ? filteredFriends : friends
//        let sectionFriends = currentFriends.filter { (friend: User) -> Bool in
//            return friend.name!.lowercased().prefix(1).contains(alphabet[indexPath.section].lowercased()) }
//        cell.set(name: sectionFriends[indexPath.row].name ?? "Name", avatar: (sectionFriends[indexPath.row].avatar.first ?? UIImage())!)
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendTableViewCell

        let sectionFriends = listFriends[alphabet[indexPath.section]]
        cell.set(name: sectionFriends?[indexPath.row].name ?? "Name", avatar: (sectionFriends?[indexPath.row].avatar.first ?? UIImage())!)
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
        for friend in friends {
            if friend.name == cell.nameLabel.text {
                let photos = friend.avatar
                collectionView.photos = photos
                collectionView.photos.append(contentsOf: allPhotos)
                break
            }
        }
        
    }
    
    // MARK: - Filter
    func filterContentForSearchText(_ searchText: String) {
        filteredFriends = friends.filter { (friend: User) -> Bool in
            return friend.name!.lowercased().contains(searchText.lowercased())
        }
        alphabetSet()
        alphabetControlSet()
        createListFriends()
        tableView.reloadData()
    }
    

}

extension FriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
