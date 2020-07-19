//
//  FriendsTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import LoremIpsum

class FriendsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let loading = LoadingAnimationView()
    
    var alphabet: [String] = []
    var currentChar: String?
    
    var friends: [User] = []
    var filteredFriends: [User] = []
    var listFriends: [String: [User]] = [:]
    
 
    //Search
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var filterChar: FilterControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupSearchController()
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loading.frame = view.frame
        tableView.addSubview(loading)
        loading.beginLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if friends.isEmpty {
            refresh()
        } else {
            loading.endLoad()
            loading.removeFromSuperview()
        }
    }
    
    //MARK: - Data loading
    
    @objc func refresh() {
        print(#function)
        
        friends = loadUsersData(amount: 5)
        
        alphabetSet()
        alphabetControlSet()
        let height = tableView.frame.height/33
        filterChar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterChar.heightAnchor.constraint(equalToConstant: CGFloat(alphabet.count) * height)
        ])
        filterChar.isHidden = false
        
        createListFriends()
        
        tableView.reloadData()
        
        loading.endLoad()
        loading.removeFromSuperview()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == alphabet.firstIndex(of: alphabet[section]) {
            let sectionFriends = listFriends[alphabet[section]]
            return sectionFriends?.count ?? 0
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = alphabet[indexPath.section]
        let user = listFriends[section]![indexPath.row]
        
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let userViewController = storyboard.instantiateViewController(identifier: "UserViewController") as! UserViewController
        
        //let meViewController = MeViewController(nibName: "MeView", bundle: nil)
        userViewController.user = user
        
        navigationController?.pushViewController(userViewController, animated: true)
    }


}


// MARK: - Filter

extension FriendsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFriends = friends.filter { (friend: User) -> Bool in
            return friend.name!.lowercased().contains(searchText.lowercased())
        }
        alphabetSet()
        alphabetControlSet()
        createListFriends()
        tableView.reloadData()
    }
    
    func setupSearchController() {
        filterChar.delegate = self
        filterChar.isHidden = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Friend"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

//MARK: - Move table to gesture char

extension FriendsTableViewController: FilterControlDelegate {
    
    func gestutePan(char: String) {
        guard char != currentChar else { return }
        print(char)
        let section = alphabet.firstIndex(of: char)!
        let indexPath = IndexPath(item: 0, section: section)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        currentChar = char
    }
}
