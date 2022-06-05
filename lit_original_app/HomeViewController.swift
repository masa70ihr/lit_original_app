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

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var homeTableView: UITableView!
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
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.postArray.count)
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        let post = postArray[indexPath.row]
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        nameLabel.text = post.name
        
        let descriptionLabel = cell.viewWithTag(2) as! UILabel
        descriptionLabel.text = post.description
        
        let option1Button = cell.viewWithTag(3) as! UIButton
        option1Button.setTitle(post.option[0], for: .normal)
        option1Button.addTarget(self, action: #selector(option1ButtonTapped(_: )), for: UIControl.Event.touchUpInside)
//        option1Button.tag = indexPath.row
        
        let option2Button = cell.viewWithTag(4) as! UIButton
        option2Button.setTitle(post.option[1], for: .normal)
        option2Button.addTarget(self, action: #selector(option2ButtonTapped(_: )), for: UIControl.Event.touchUpInside)
//        option2Button.tag = indexPath.row
        
        return cell
    }
    
    @objc func option1ButtonTapped(_ sender: UIButton){
        print("option1ButtonTappedがタップされました", [sender.tag])
    }
    
    @objc func option2ButtonTapped(_ sender: UIButton){
        print("option2ButtonTappedがタップされました", [sender.tag])
    }
    
    @IBAction func pushedButton1(sender: UIButton) {
        //UITableView内の座標に変換
        let point = homeTableView.convert(sender.center, from: sender)
        print(point)
        //座標からindexPathを取得
        if let indexPath = homeTableView.indexPathForRow(at: point) {
            print(indexPath.row)
        } else {
            //ここには来ないはず
            print("not found...")
        }
    }
    
    @IBAction func pushedButton2(sender: UIButton) {
        //UITableView内の座標に変換
        let point = homeTableView.convert(sender.center, from: sender)
        print(point)
        //座標からindexPathを取得
        if let indexPath = homeTableView.indexPathForRow(at: point) {
            print(indexPath.row)
        } else {
            //ここには来ないはず
            print("not found...")
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 241
//        }

}
