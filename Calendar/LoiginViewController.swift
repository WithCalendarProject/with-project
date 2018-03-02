//
//  LoiginViewController.swift
//  Calendar
//
//  Created by 川村周也 on 2018/02/13.
//  Copyright © 2018年 川村周也. All rights reserved.
//

import UIKit
import Firebase

class LoiginViewController: UIViewController {
    
    @IBOutlet weak var mailAddressText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func onTouchedSignUpButton(_ sender: Any) {
        if let email = mailAddressText.text, let password = passwordText.text {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
                self?.validateAuthenticationResult(user, error: error)
            }
        }
    }
    
    @IBAction func onTouchedLogInButton(_ sender: Any) {
        if let email = mailAddressText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
                self?.validateAuthenticationResult(user, error: error)
            }
        }
    }
    
    private func validateAuthenticationResult(_ user: User?, error: Error?) {
        if error != nil{
            let alert = UIAlertController(title: "ログインエラー", message: "メールアドレスもしくはパスワードが違います。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "toHome", sender: self)
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
