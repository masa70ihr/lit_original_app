//
//  HomeViewController.swift
//  lit_original_app
//
//  Created by MASANAO on 2022/06/03.
//

import UIKit
import FirebaseFirestore

class Post {
    var uid: String
    var postUserId: String
    var name: String
    var description: String
    var option: [String]
    var countResult: [Int]
    var createdAt: Timestamp
    
    init(document: QueryDocumentSnapshot) {
        self.uid = document.documentID
        let Dic = document.data()
        self.postUserId = Dic["postUserId"] as! String
        self.name = Dic["name"] as! String
        self.description = Dic["description"] as! String
        self.option = Dic["option"] as! [String]
        self.countResult = Dic["countResult"] as! [Int]
        self.createdAt = Dic["createdAt"] as! Timestamp
    }
}

//class Option {
//    var uid: String
//    var contentId: String
//    var title: String
//    var countResult: String
//    var createdAt: Timestamp
//
//    init(document: QueryDocumentSnapshot) {
//        self.uid = document.documentID
//        let Dic = document.data()
//        self.contentId = Dic["contentId"] as! String
//        self.title = Dic["title"] as! String
//        self.countResult = Dic["countResult"] as! String
//        self.createdAt = Dic["createdAt"] as! Timestamp
//    }
//}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView! {
        didSet {
            homeTableView.delegate = self
            homeTableView.dataSource = self
            //nibNameはCustomCellのクラス名、forCellReuseIdentifierは適当なcellを使うときに判別するkey
            homeTableView.register(UINib(nibName:"PostTableViewCell", bundle: nil),forCellReuseIdentifier:"PostCell")
        }
    }
    
    var postArray: [Post]!
//    var option1ButtonArray: [Int] = []
//    var option2ButtonArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.postArray = []
        let postRef = Firestore.firestore().collection("posts")
        
        postRef.order(by: "createdAt", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("post情報の取得に失敗しました。", err)
                return
            }
            print("post情報の取得に成功しました。")
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                let data = Post(document: document)
                self.postArray.append(data)
            }
//            self.postArray = querySnapshot!.documents.map { document in
//                let data = Post(document: document)
//                print(data.name)
//                return data
//            }
            print(self.postArray.count)
            
            // すべてユーザーリストに格納したら、TableViewを更新する。
            self.homeTableView.reloadData()
        }
    }
}
    
    
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.postArray.count)
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = postArray[indexPath.row]
        
        cell.nameLabel.text = post.name
        
        cell.descriptionLabel.text = post.description
        
        if #available(iOS 15.0, *) {
            cell.option1Button.configuration = nil
            cell.option2Button.configuration = nil
        }
        
        cell.option1Button.setTitle(post.option[0], for: .normal)
        cell.option1Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        cell.option1Button.addTarget(self, action: #selector(option1ButtonTapped(_: )), for: UIControl.Event.touchUpInside)
        cell.option1Button.tag = indexPath.row
        
        cell.option2Button.setTitle(post.option[1], for: .normal)
        cell.option2Button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20)
//        cell.option2Button.addTarget(self, action: #selector(option2ButtonTapped(_: )), for: UIControl.Event.touchUpInside)
        cell.option2Button.tag = indexPath.row
        
        cell.delegate = self
        
        return cell
    }
    
    @objc func option1ButtonTapped(_ sender: UIButton){
        print("option1ButtonTappedがタップされました", [sender.tag])
//        updateCountResult(optionButton: sender)
    }
    
    @objc func option2ButtonTapped(_ sender: UIButton){
        print("option2ButtonTappedがタップされました", [sender.tag])
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
//    private  func updateCountResult(optionButton: UIButton) {
//        let postRef = Firestore.firestore().collection("posts")
//
//        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
//            let sfDocument: DocumentSnapshot
//        }, completion: <#(Any?, Error?) -> Void#>)
//    }
    
    
//    @IBAction func pushedButton1(sender: UIButton) {
//        //UITableView内の座標に変換
//        let point = homeTableView.convert(sender.center, from: sender)
//        print(point)
//        //座標からindexPathを取得
//        if let indexPath = homeTableView.indexPathForRow(at: point) {
//            print(indexPath.row)
//        } else {
//            //ここには来ないはず
//            print("not found...")
//        }
//    }
//
//    @IBAction func pushedButton2(sender: UIButton) {
//        //UITableView内の座標に変換
//        let point = homeTableView.convert(sender.center, from: sender)
//        print(point)
//        //座標からindexPathを取得
//        if let indexPath = homeTableView.indexPathForRow(at: point) {
//            print(indexPath.row)
//        } else {
//            //ここには来ないはず
//            print("not found...")
//        }
//    }
}

extension HomeViewController: CustomCellDelegate {
    func didTapOption1Button(sender: UIButton, cell: PostTableViewCell) {
        print("tapped option1Button", sender.tag)
        sender.backgroundColor = UIColor.rgb(red: 46, green: 185, blue: 203)
        sender.tintColor = UIColor.white
        let buttonTag = sender.tag
        guard let button2tintColor = cell.option2Button.viewWithTag(buttonTag)?.tintColor else { return }
        changeButtonColor(tintColer: button2tintColor, targetOptionButton: cell.option2Button, buttonTag: buttonTag)
    }
    
    func didTapOption2Button(sender: UIButton, cell: PostTableViewCell) {
        print("tapped option2Button", sender.tag)
        sender.backgroundColor = UIColor.rgb(red: 46, green: 185, blue: 203)
        sender.tintColor = UIColor.white
        let buttonTag = sender.tag
        guard let button1tintColor = cell.option1Button.viewWithTag(buttonTag)?.tintColor else { return }
        changeButtonColor(tintColer: button1tintColor, targetOptionButton: cell.option1Button, buttonTag: buttonTag)
    }
    
    private func changeButtonColor(tintColer: UIColor, targetOptionButton: UIButton, buttonTag: Int) {
        if tintColer == UIColor.white {
            targetOptionButton.viewWithTag(buttonTag)?.backgroundColor = nil
            targetOptionButton.viewWithTag(buttonTag)?.tintColor = UIColor.rgb(red: 46, green: 185, blue: 203)
        }
    }
    
    private func updateCountResult(buttonTag: Int, tappedButtonIndex: Int, totalOptionsNum: Int) {
        let postUid = self.postArray[buttonTag].uid
        // 更新するPostのDocumentReference
        let postReference: DocumentReference = Firestore.firestore().collection("Post").document(postUid)
        
        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                // 更新するCoupon
                let document: DocumentSnapshot = try transaction.getDocument(postReference)
                let data = Post(document: document as! QueryDocumentSnapshot)
                // クーポンを使用したUserに付与するポイントをCouponから取得する
                let countResult: Int = data.countResult[tappedButtonIndex]

                // 更新するUser
                let user: DocumentSnapshot = try transaction.getDocument(userReference)
                // ユーザーが現在持っているポイントをUserから取得する
                let toPoint: Int = userSnapshot.data()!["point"] as? Int ?? 0

                // Userの持っているポイントにCouponのポイントを加算して更新する
                transaction.setData(["point" : toPoint + point], forDocument: userReference, merge: true)

                // CouponのUsersに使用したUserを保存する
                transaction.setData(userSnapshot.data()!, forDocument: usersReference, merge: true)
            } catch (let error) {
                print(error)
            }
            return nil
        }, completion: { (_, error)  in
            if let error = error {
                print(error)
                return
            }
        })
    }
}


