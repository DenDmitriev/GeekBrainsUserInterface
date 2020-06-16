//
//  ViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 12.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fieldView: UIView!
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var horizontalLine = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 8
        loginButton.backgroundColor = UIColor(displayP3Red: 70/255, green: 128/255, blue: 194/255, alpha: 0.5)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.isEnabled = false
        
        fieldView.layer.cornerRadius = 8
        fieldView.layer.borderWidth = 0.33
        fieldView.layer.borderColor = UIColor.gray.cgColor
        
        horizontalLine = UIView(frame: CGRect(x: 0, y: loginField.frame.height, width: fieldView.frame.width, height: 0.33))
        horizontalLine.backgroundColor = .gray
        fieldView.addSubview(horizontalLine)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        print(#function)
        guard let kbSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
    }
    
    @objc func keyboardHideShow(notification: Notification) {
        print(#function)
        scrollView.contentInset = .zero
    }

    @IBAction func scrollTapped(gesture: UIGestureRecognizer) {
        print(#function)
        scrollView.endEditing(true)
        
        if loginField.text != "" && passwordField.text != "" {
            loginButton.backgroundColor = UIColor(displayP3Red: 70/255, green: 128/255, blue: 194/255, alpha: 1)
            loginButton.isEnabled = true
        }
        
    }
    
    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        print("Login: \(loginField.text) and Password: \(passwordField.text)")
    }
    
}

