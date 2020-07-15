//
//  UserViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 25.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import LoremIpsum

class UserViewController: UIViewController {
    
    var user: User = User(name: "Name Surname", avatar: [UIImage()])
    
    @IBOutlet weak var avatatImage: AvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var photos: [UIImage] = []

    
    @IBOutlet weak var collectionViewPhoto: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(user: user)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAvatar))
        avatatImage.addGestureRecognizer(tapGesture)
        
        title = user.name
    }
    
    func setup(user: User) {
        avatatImage.image = user.avatar.first ?? UIImage()
        nameLabel.text = user.name
        
        photos = user.avatar
        
        setupItemCollectionView()
    }
    
    @objc func tapAvatar() {
        Preview().previewImage(imageView: avatatImage.imageView, navigationController: navigationController, darkRoom: false)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toCollectionPhoto":
            let collectionPhoto = segue.destination as! PhotosCollectionViewController
            collectionPhoto.photos = user.avatar
        default:
            return
        }
    }
    
    
    
}

extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Data source
    
    func setupItemCollectionView() {
        collectionViewPhoto.register(UINib(nibName: "PhotosMiniCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "item")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewPhoto.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! PhotosMiniCollectionViewCell
        let image = photos[indexPath.item]
        cell.set(image: image)
        return cell
    }
    
    //MARK: Navigation
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionViewPhoto.cellForItem(at: indexPath) as! PhotosMiniCollectionViewCell
        
        let photosViewController = PhotosViewController(nibName: "PhotosViewController", bundle: nil)
        photosViewController.image = cell.imageView.image
        photosViewController.photos = user.avatar
        
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    //MARK: Layout
    
    enum Layout {
        static let items: CGFloat = 3
        static let separator: CGFloat = 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - (Layout.separator * Layout.items - 1)) / Layout.items
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
    
}


