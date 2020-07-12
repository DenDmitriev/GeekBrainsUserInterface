//
//  PhotosViewController.swift
//  VK
//
//  Created by Denis Dmitriev on 08.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    var photos: [UIImage?] = []
    var uiHidden: Bool = false
    var animator = UIViewPropertyAnimator()
    
    var startPoint = CGPoint()
    var assistImageView = UIImageView()
    var defaultCenter = CGPoint()
    var defaultFrame = CGRect()
    var direction: Direction = .next
    var currentIndex = 1 {
        didSet {
            title = "\(currentIndex) из \(photos.count)"
        }
    }
    
    enum Control {
        static let cancel: CGFloat = 25
        static let duration: TimeInterval = 0.5
    }
    
    enum Direction {
        case next
        case previous
        case none
    }
    

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = photos.first ?? UIImage()

        setupGestures()
        
        defaultCenter = imageView.center
        defaultFrame = imageView.frame
        assistImageView.frame = defaultFrame
        assistImageView.backgroundColor = .clear
        assistImageView.contentMode = .scaleAspectFit
        
        title = "\(currentIndex) из \(photos.count)"
    }
    
    @objc func tabView() {
        print(#function)
        uiHidden = !uiHidden
        navigationController?.navigationBar.isHidden = uiHidden
        tabBarController?.tabBar.isHidden = uiHidden
    }
    
    func setupGestures() {
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(tabView))
        imageView.addGestureRecognizer(tabGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        
        let gestures = [panGesture, tabGesture]
        
        gestures.forEach { gesture in
            imageView.addGestureRecognizer(gesture)
        }
    }
    
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {

        let translation = sender.translation(in: self.view)
        
        let index = photos.firstIndex(of: imageView.image)
        
        switch sender.state {
        case .began:
            
            startPoint = sender.location(in: self.view)
            
            animator = UIViewPropertyAnimator(duration: Control.duration, curve: .easeInOut) {
                self.imageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }
            
            animator.addAnimations({
                self.assistImageView.center = self.imageView.center
            }, delayFactor: 1/4)
            
            animator.addAnimations({
                self.imageView.alpha = 0.1
            }, delayFactor: 2/4)
            
            animator.addCompletion { _ in
                self.imageView.alpha = 1
                self.imageView.transform = CGAffineTransform.identity
                self.assistImageView.removeFromSuperview()
                self.assistImageView.center = self.defaultCenter
                self.assistImageView.frame = self.defaultFrame
            }
            
            if translation.x < 0 {
                switch index {
                case photos.count-1:
                    print("last photo")
                    animator.stopAnimation(true)
                    toDefault()
                default:
                    assistImageView.center.x += defaultFrame.width
                    assistImageView.image = photos[index!+1]
                    view.addSubview(assistImageView)
                    direction = .next
                }
            } else {
                switch index {
                case 0:
                    print("first photo")
                    animator.stopAnimation(true)
                    toDefault()
                default:
                    assistImageView.center.x -= defaultFrame.width
                    assistImageView.image = photos[index!-1]
                    view.addSubview(assistImageView)
                    direction = .previous
                }
            }
            
        case .changed:
            
            let endPoint = sender.location(in: self.view)
            let deltaY = startPoint.y - endPoint.y
            if abs(translation.x) < abs(translation.y) && abs(deltaY) > Control.cancel*2  {
                navigationController?.popViewController(animated: true)
            }
            
            switch direction {
            case .next:
                if translation.x >= 0 {
                    direction = .none
                    animator.stopAnimation(true)
                    toDefault()
                } else {
                    direction = .next
                    animator.fractionComplete = abs(translation.x / 100)
                }
            case .previous:
                if translation.x < 0 {
                    direction = .none
                    animator.stopAnimation(true)
                    toDefault()
                } else {
                    direction = .previous
                    animator.fractionComplete = abs(translation.x / 100)
                }
            default:
                return
            }
        case .ended:
            let endPoint = sender.location(in: self.view)
            let deltaX = startPoint.x - endPoint.x
            if  abs(deltaX) > Control.cancel {
                switch direction {
                case .next:
                    print("next photo")
                    presentPhoto(direction: .next, index: index!)
                case .previous:
                    print("previos photo")
                    presentPhoto(direction: .previous, index: index!)
                case .none:
                    animator.stopAnimation(true)
                    toDefault()
                }
            } else {
                animator.stopAnimation(true)
                toDefault()
            }
        default:
            return
        }
    }
    
    func toDefault() {
        self.imageView.alpha = 1
        self.imageView.transform = CGAffineTransform.identity
        self.assistImageView.removeFromSuperview()
        self.assistImageView.center = self.defaultCenter
        self.assistImageView.frame = self.defaultFrame
    }
    
    
    func presentPhoto(direction: Direction, index: Int) {
        switch direction {
        case .next:
            switch index {
            case photos.count-1:
                animator.stopAnimation(true)
                toDefault()
            default:
                animator.addCompletion { _ in
                    self.imageView.image = self.photos[index+1]
                }
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                currentIndex = index+2
            }
        case .previous:
            switch index {
            case 0:
                animator.stopAnimation(true)
                toDefault()
            default:
                animator.addCompletion { _ in
                    self.imageView.image = self.photos[index-1]
                }
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                currentIndex = index
            }
        default:
            return
        }
    }
    

}
