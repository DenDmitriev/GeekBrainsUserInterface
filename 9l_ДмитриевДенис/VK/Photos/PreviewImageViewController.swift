//
//  PreviewImageViewController.swift
//  VK
//
//  Created by Denis Dmitriev on 11.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewImageViewController: UIViewController {
    
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        
                
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(cancel(_:)))
        swipeGesture.direction = .up
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func cancel() {
        let imageFrame = AVMakeRect(aspectRatio: imageView.image?.size ?? imageView.frame.size, insideRect: imageView.bounds)

        let customTransitionDelegate = TransitionDelegate(frame: imageFrame)
        self.transitioningDelegate = customTransitionDelegate
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        cancel()
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
