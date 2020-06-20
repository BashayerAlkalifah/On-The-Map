//
//  LoginViewController.swift
//  on the map
//
//  Created by بشاير الخليفه on 16/03/1441 AH.
//  Copyright © 1441 -. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func login(_ sender: Any) {
        
         API.createSession(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: sessionHelper(success:error:errorMessage:))
    }
    func sessionHelper(success: Bool, error: Error?, errorMessage: String) {
          if success {
              DispatchQueue.main.async {
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab") as! UITabBarController
                  vc.modalPresentationStyle = .fullScreen
                  self.show(vc, sender: nil)
              }
          } else {
                 self.alert(title: "Login Failed", message: errorMessage )
    
          }
      }
      
}



