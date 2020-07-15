//
//  LentaTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 01.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import LoremIpsum
import AVFoundation

class LentaTableViewController: UITableViewController {
    
    let loading = LoadingCloudView()
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        registerCell()
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
        if posts.isEmpty {
            refresh()
        } else {
            loading.endLoad()
            loading.removeFromSuperview()
        }
    }
    
    //MARK: - Data loading
    
    @objc func refresh() {
        print(#function)
        
        posts = loadPostsData(amount: 10)
        tableView.reloadData()

        loading.endLoad()
        loading.removeFromSuperview()
    }
    

    // MARK: - Table view data source
    
    func registerCell() {
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        cell.set(post: posts[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell: PostTableViewCell = cell as! PostTableViewCell
        cell.alpha = 0
        cell.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
            cell.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell: PostTableViewCell = cell as! PostTableViewCell
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 0
            cell.view.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
        
        let imageFrame = AVMakeRect(aspectRatio: cell.postImageView.image?.size ?? cell.postImageView.frame.size, insideRect: cell.postImageView.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(identifier: "PreviewImageViewController") as! PreviewImageViewController
        destinationViewController.modalPresentationStyle = .fullScreen
        
        let customTransitionDelegate = TransitionDelegate(frame: imageFrame)
        
        destinationViewController.transitioningDelegate = customTransitionDelegate
        destinationViewController.image = cell.postImageView.image
        
        present(destinationViewController, animated: true, completion: nil)
    }
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
