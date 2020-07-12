//
//  PhotosViewController.swift
//  VK
//
//  Created by Denis Dmitriev on 08.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import AVFoundation

class PhotosViewController: UIViewController {
    
    var photos: [UIImage?] = []
    
    lazy var uiHidden: Bool = false
    lazy var animator = UIViewPropertyAnimator()
    
    lazy var assistImageView = UIImageView()
    
    lazy var defaultCenter = CGPoint()
    lazy var defaultFrame = CGRect()
    
    lazy var move: CGFloat = 0
    
    var currentIndex = 0 {
        didSet {
            title = "\(currentIndex+1) из \(photos.count)"
        }
    }
    
    lazy var currentDirection: Direction = .next
    
    enum Control {
        static let separator: CGFloat = 10
        static let duration: TimeInterval = 0.5
    }
    
    enum Direction {
        case next, previous
        
        init(x: CGFloat) {
            self = x > 0 ? .previous : .next
        }
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
    
        currentIndex = photos.firstIndex(of: imageView.image) ?? 0
        title = "\(currentIndex+1) из \(photos.count)"
    }
    
    @objc func tabView(sender: UITapGestureRecognizer) {
        print(#function)
        let imageFrame = AVMakeRect(aspectRatio: imageView.image?.size ?? imageView.frame.size, insideRect: imageView.bounds)
        if imageFrame.contains(sender.location(in: sender.view)) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyboard.instantiateViewController(identifier: "PreviewImageViewController") as! PreviewImageViewController
            destinationViewController.modalPresentationStyle = .fullScreen
            
            let heightNC = navigationController?.navigationBar.frame.height ?? 0
            let correctImageFrame = CGRect(
                x: 0,
                y: imageFrame.minY + heightNC,
                width: imageFrame.width,
                height: imageFrame.height)
            let customTransitionDelegate = TransitionDelegate(frame: correctImageFrame)
            
            destinationViewController.transitioningDelegate = customTransitionDelegate
            destinationViewController.image = imageView.image
            
            present(destinationViewController, animated: true, completion: nil)
        } else {
            uiHidden = !uiHidden
            navigationController?.navigationBar.isHidden = uiHidden
            tabBarController?.tabBar.isHidden = uiHidden
        }
        
    }
    
    func setupGestures() {
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(tabView))
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        
        let gestures = [panGesture, tabGesture]
        
        gestures.forEach { gesture in
            imageView.addGestureRecognizer(gesture)
        }
    }
    
    func gestureAniamtionSetup(direction: Direction, nextIndex: Int) {
        
        currentDirection = direction
        
        switch direction {
        case .next:
            assistImageView.center.x += (view.frame.width + Control.separator)
            move = -(view.frame.width + Control.separator)
        case .previous:
            assistImageView.center.x -= (view.frame.width + Control.separator)
            move = +(view.frame.width + Control.separator)
        }
        
        assistImageView.image = photos[nextIndex]
        view.addSubview(assistImageView)
        
        animator = UIViewPropertyAnimator(duration: Control.duration, curve: .easeInOut) {
            self.imageView.center.x += self.move
            self.assistImageView.center = self.defaultCenter
        }
        
        animator.addCompletion { position in
            guard position == .end else { return }
            self.imageView.center = self.defaultCenter
            self.assistImageView.removeFromSuperview()
            self.assistImageView.center = self.defaultCenter
            self.currentIndex = nextIndex
            self.imageView.image = self.photos[nextIndex]
        }
        
    }
    
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        
        
        let translation = sender.translation(in: sender.view)
        let direction = Direction(x: translation.x)
        
        guard ready(direction: direction, index: currentIndex) else {
            animator.stopAnimation(true)
            toDefault(direction: direction)
            return
        }
        
        let nextIndex = direction == .next ? currentIndex + 1 : currentIndex - 1
        
        switch sender.state {
        case .began:
            
            gestureAniamtionSetup(direction: direction, nextIndex: nextIndex)
            
            //animator.pauseAnimation()

        case .changed:
            
            if direction == currentDirection {
                animator.fractionComplete = abs(translation.x) / sender.view!.frame.width
            } else {
                animator.stopAnimation(true)
                
                self.assistImageView.removeFromSuperview()
                self.assistImageView.center = self.defaultCenter
                
                gestureAniamtionSetup(direction: direction, nextIndex: nextIndex)
            }
            
        case .ended:
            
            if  animator.fractionComplete > 0.25 {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {
                animator.stopAnimation(true)
                toDefault(direction: direction)
            }
            
        default:
            break
        }
    }
    
    func ready(direction: Direction, index: Int) -> Bool {
        switch direction {
        case .next:
            guard index != photos.count-1 else { return false }
        case .previous:
            guard index != 0 else { return false }
        }
        return true
    }
    
    func toDefault(direction: Direction) {
        UIView.animate(withDuration: 0.25, animations: {
            self.imageView.center = self.defaultCenter
            switch direction {
            case .next: self.assistImageView.center.x = self.view.frame.width*3/2 + Control.separator
            case .previous: self.assistImageView.center.x = -self.view.frame.width/2 - Control.separator
            }
            
        }) { _ in
            self.assistImageView.removeFromSuperview()
            self.assistImageView.center = self.defaultCenter
        }
    }
    

}
