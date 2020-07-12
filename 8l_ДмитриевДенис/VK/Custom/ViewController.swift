//
//  ViewController.swift
//  VK
//
//  Created by Denis Dmitriev on 08.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewShpae: LoadingCloudView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func play(_ sender: UIButton) {
        viewShpae.beginLoad()
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
