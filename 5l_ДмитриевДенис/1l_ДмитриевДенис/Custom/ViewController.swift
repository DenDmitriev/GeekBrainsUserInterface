//
//  ViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 25.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var photos: [UIImage?] = [
        UIImage(named: "Бенедикт Харди"),
        UIImage(named: "Брайан Браун"),
        UIImage(named: "Джек Томпсон"),
        UIImage(named: "Дженнифер Коннелли"),
        UIImage(named: "Майкл Фассбендер"),
        UIImage(named: "Марион Котийяр"),
        UIImage(named: "Рэйчел Вайс"),
        UIImage(named: "Эмили Барклай"),
        UIImage(named: "Донал Глисон"),
        UIImage(named: "Лидия Уилсон"),
        UIImage(named: "Линдси Дункан")
    ]

    @IBOutlet weak var liker: LikeControl!
    
    @IBOutlet weak var collectionViewPhoto: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Бен Кингсли"
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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


