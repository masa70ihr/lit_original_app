//
//  LoginViewController.swift
//  lit_original_app
//
//  Created by MASANAO on 2022/05/25.
//

import UIKit
import FirebaseAuth
import PKHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BGButton!
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func toCreateAccount() {
        performSegue(withIdentifier: "toCreateAccount", sender: nil)
    }
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        HUD.show(.progress, onView: view)
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        self.handleLogin(email: email, password: password)
    }
    
    private func handleLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("ログイン情報の取得に失敗しました。", err)
                return
            }
            print("ログインに成功しました。")
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            homeViewController.modalPresentationStyle = .fullScreen
            homeViewController.modalTransitionStyle = .crossDissolve
            HUD.hide { (_) in
                HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                    self.present(homeViewController, animated: true)
                    print("ホーム画面に遷移")
                }
            }
        }
    }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
//            loginButton.backgroundColor = UIColor.rgb(red: 127, green: 211, blue: 211)
        } else {
            loginButton.isEnabled = true
        }
    }
}
