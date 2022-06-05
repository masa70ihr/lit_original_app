//
//  CreateAccountViewController.swift
//  lit_original_app
//
//  Created by MASANAO on 2022/05/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PKHUD

struct User {
    let name: String
    let email: String
    let createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.email = dic["email"] as! String
        self.createdAt = dic ["createdAt"] as! Timestamp
    }
}

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: BGButton!
    @IBOutlet weak var buttonView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createAccountButton.isEnabled = false
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else { return }
        let buttonViewMaxY = buttonView.frame.maxY
        
        let usernameIsEditing = usernameTextField.isEditing
        let emailIsEditing = emailTextField.isEditing
        let passwordIsEditing = passwordTextField.isEditing
        
        var distance = (buttonViewMaxY - keyboardMinY) / 3
        
        if usernameIsEditing {
            print("username is editing")
            distance *= 1
        } else if emailIsEditing {
            print("email is editing")
            distance *= 2
        } else if passwordIsEditing {
            print("password is editing")
            distance *= 3
        }
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {self.view.transform = transform})
    }
    
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {self.view.transform = .identity})
        print("hideKeyboard is hiding")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func tappedCreateButton(_ sender: Any) {
        print("tapped CreateButton")
        handleAuthToFirebase()
    }
    
    private func handleAuthToFirebase() {
        HUD.show(.progress, onView: view)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました。\(err)")
                HUD.hide { (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            self.addUserInfoToFirestore(email: email)
        }
    }
    
    private func addUserInfoToFirestore(email: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let name = self.usernameTextField.text else { return }
        
        let docData = ["email": email, "name": name, "createdAt": Timestamp()]  as [String : Any]
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.setData(docData) { (err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
                HUD.hide { (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            print("Firestoreへの保存に成功しました。")
            HUD.hide { (_) in
                HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                    self.handleLogout()
                }
            }
            
            userRef.getDocument { (snapshot, err) in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    return
                }
                
                guard let data = snapshot?.data() else { return }
                let user = User.init(dic: data)
                print("ユーザー情報の取得に成功しました。\(user.name)")
            }
        }
    }
    
    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            print("ログアウトに成功しました。")
            dismiss(animated: true, completion: nil)
        } catch (let err) {
            print("ログアウトに失敗しました。\(err)")
        }
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITextFieldDelegate
extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? true
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if usernameIsEmpty || emailIsEmpty || passwordIsEmpty {
            createAccountButton.isEnabled = false
//            createAccountButton.backgroundColor = UIColor.rgb(red: 127, green: 211, blue: 211)
        } else {
            createAccountButton.isEnabled = true
        }
    }
}
