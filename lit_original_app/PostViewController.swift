//
//  PostViewController.swift
//  lit_original_app
//
//  Created by MASANAO on 2022/06/03.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PKHUD

class PostViewController: UIViewController {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var option1TextField: UITextField!
    @IBOutlet weak var option2TextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    var user: User!
    var currentUseruid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.isEnabled = false
        descriptionTextField.delegate = self
        option1TextField.delegate = self
        option2TextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentUseruid = Auth.auth().currentUser!.uid
        let userRef = Firestore.firestore().collection("users").document(self.currentUseruid)
        userRef.getDocument { (snapshot, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
            } else {
                guard let data = snapshot?.data() else { return }
                self.user = User.init(dic: data)
                print("ユーザー情報の取得に成功しました。\(self.user.name)")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func tappedPostButton(_ sender: Any) {
        print("tapped PostButton!")
        addPostInfoToFirestore()
    }
    
    private func addPostInfoToFirestore() {
        HUD.show(.progress, onView: view)
        guard let description = descriptionTextField.text else { return }
        guard let option1 = option1TextField.text else { return }
        guard let option2 = option2TextField.text else { return }
        
        
        let docData = ["postUserId": self.currentUseruid as Any, "name": self.user.name, "description": description, "option": [option1, option2], "countResult": [0, 0], "createdAt": Timestamp()]  as [String : Any]
        let postRef = Firestore.firestore().collection("posts")
        var ref: DocumentReference? = nil
        
        ref = postRef.addDocument(data: docData) { err in
            if let err = err {
                print("postの保存に失敗しました。", err)
                return
            }
            print("post document added with ID: \(ref!.documentID)")
            HUD.hide { (_) in
                HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                    print("画面遷移")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
//    private func getCurrentUserInfo(currentUseruid: String)  {
//        let userRef = Firestore.firestore().collection("users").document(currentUseruid)
//        userRef.getDocument { (snapshot, err) in
//            if let err = err {
//                print("ユーザー情報の取得に失敗しました。\(err)")
//                return
//            }
//            guard let data = snapshot?.data() else { return }
//            self.user = User.init(dic: data)
//            print("ユーザー情報の取得に成功しました。\(self.user.name)")
//        }
//    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITextFieldDelegate
extension PostViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let descriptionIsEmpty = descriptionTextField.text?.isEmpty ?? true
        let option1IsEmpty = option1TextField.text?.isEmpty ?? true
        let option2IsEmpty = option2TextField.text?.isEmpty ?? true
        
        if descriptionIsEmpty || option1IsEmpty || option2IsEmpty {
            postButton.isEnabled = false
//            createAccountButton.backgroundColor = UIColor.rgb(red: 127, green: 211, blue: 211)
        } else {
            postButton.isEnabled = true
        }
    }
}
