//
//  MeViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 25.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import LoremIpsum

class MeViewController: UIViewController {
    
    @IBOutlet weak var avatatImage: AvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var photos: [UIImage?] = []

    
    @IBOutlet weak var collectionViewPhoto: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    
    //MARK: - Data loading
    
    func loadData() {
        print(#function)
        avatatImage.image = LoremIpsum.placeholderImage(from: .placeKitten, with: CGSize(width: 100, height: 100))
        nameLabel.text = LoremIpsum.name()
        for _ in 1...5 {
            photos.append(LoremIpsum.placeholderImage(from: .placeKitten, with: CGSize(width: Int.random(in: 200...500), height: Int.random(in: 100...300))))
        }
        collectionViewPhoto.reloadData()

    }
    

}

extension MeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewPhoto.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! PhotoCollectionViewCell
        cell.set(photo: photos[indexPath.item]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = photos[indexPath.row]
        let heighImage = image!.size.height
        let widthImage = image!.size.width
        let aspect = widthImage/heighImage
        
        let height = collectionViewPhoto.frame.height
        let width = aspect * height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(8)
    }
    
}


