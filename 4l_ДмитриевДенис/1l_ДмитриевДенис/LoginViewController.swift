//
//  ViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 12.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 8
        loginButton.setTitleColor(.white, for: .normal)
        buttonStatus(button: loginButton, status: false)
        
        typingField(loginField)
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
    }
    
    @IBAction func typingField(_ sender: UITextField) {
        print(#function)
        if loginField.text != "" && passwordField.text != "" {
            buttonStatus(button: loginButton, status: true)
        } else {
            buttonStatus(button: loginButton, status: false)
        }
    }
    
    func buttonStatus(button: UIButton, status: Bool) {
        if status {
            button.backgroundColor = UIColor(displayP3Red: 70/255, green: 128/255, blue: 194/255, alpha: 1)
        } else {
            button.backgroundColor = UIColor(displayP3Red: 70/255, green: 128/255, blue: 194/255, alpha: 0.5)
        }
        button.isEnabled = status
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loginSegue" {
            return checkLogin(login: loginField.text, password: passwordField.text)
        } else {
            return false
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabController = storyboard.instantiateViewController(identifier: "tabController")
        tabController.modalPresentationStyle = .fullScreen
        present(tabController, animated: true)
    }
    
    
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        print(#function)
    }
    
    func checkLogin(login: String?, password: String?) -> Bool {
        if login == "admin" && password == "admin" {
            return true
        } else {
            loginError()
            return false
        }
    }
    
    func loginError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не верный логин или пароль, попробуй: логин admin, пароль admin",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}

