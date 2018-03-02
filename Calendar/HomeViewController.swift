//
//  HomeViewController.swift
//  Calendar
//
//  Created by 川村周也 on 2018/01/03.
//  Copyright © 2018年 川村周也. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    let ref = Database.database().reference() //FirebaseDatabaseのルートを指定
    let firebaseManager = FirebaseManager()
    var userInfo: [DataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var followings: [DataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    var followSnap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    var items:Dictionary<String, AnyObject> = [:]
    var myID = ""
    var userID = ""
    
    @IBOutlet weak var homeBottomView: UIView!
    @IBOutlet weak var friendView: UITableView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var ComentLabel: UILabel!
    @IBOutlet weak var IconImage: UIImageView!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    
    
    
    //logoutボタンを押した時の処理
    @IBAction func onTapLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()   //logoutする
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func UserButton(_ sender: Any) {
        
        
    }
    
    func read()  {
        
        firebaseManager.readDataNomal(function: {() -> () in
            
            if !self.firebaseManager.contentArray.isEmpty{
            //配列の該当のデータをitemという定数に代入
            let item = self.firebaseManager.contentArray[0]
            //itemの中身を辞書型に変換
            let content = item.value as! Dictionary<String, AnyObject>
            //
            self.NameLabel.text = String(describing: content["userName"]!)
            self.IDLabel.text = String(describing: content["userID"]!)
            self.ComentLabel.text = String(describing: content["coment"]!)
            self.IconImage = UIImageView(image: #imageLiteral(resourceName: "User"))
            
            self.IDLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
            self.IDLabel.textColor = UIColor.lightGray
            self.IDLabel.textAlignment = NSTextAlignment.center
            
            self.NameLabel.sizeToFit()
            self.IDLabel.sizeToFit()
            self.ComentLabel.sizeToFit()
            }
            
        } , key: (Auth.auth().currentUser?.uid)!, "userInfomation")
        
        

        
        
        /*
        ref.child("friends")
            .child("follower")
            .observe(.value, with: {(snapShots) in
                if snapShots.children.allObjects is [DataSnapshot] {
                    print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                    
                    print("snapShot...\(snapShots)") //読み込んだデータをプリント
                    
                    self.followSnap = snapShots
                    
                }
                self.reload(snap: self.followSnap)
            })*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        firebaseManager.readDataFilter(function: {() -> () in
            
            if !self.firebaseManager.contentArray.isEmpty{
            let item = self.firebaseManager.contentArray[0]
            let content = item.value as! Dictionary<String, AnyObject>
            self.myID = String(describing: content["userID"]!)
            
            self.firebaseManager.readDataNomal(function: {() -> () in
                
                if !self.firebaseManager.contentArray.isEmpty{
                let item = self.firebaseManager.contentArray[0]
                //itemの中身を辞書型に変換
                let content = item.value as! Dictionary<String, AnyObject>
                
                self.followLabel.text = String(content.count)
                }
                
            }, key: "friends","following","\(self.myID)")
            
            self.firebaseManager.readDataNomal(function: {() -> () in
                
                if !self.firebaseManager.contentArray.isEmpty{
                    let item = self.firebaseManager.contentArray[0]
                    //itemの中身を辞書型に変換
                    let content = item.value as! Dictionary<String, AnyObject>
                    
                    self.followerLabel.text = String(content.count)
                }
                
            }, key: "friends","follower","\(self.myID)")
            }
            
        }, sortKey: "accountID", targetValue: firebaseManager.accountID, key: "userList", "users")
            
        
        self.read()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        //上線のCALayerを作成
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: homeBottomView.frame.width, height: 1.0)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        
        //下線のCALayerを作成
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: friendView.frame.height, width: friendView.frame.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        
        //作成したViewに上線を追加
        homeBottomView.layer.addSublayer(topBorder)
        friendView.layer.addSublayer(bottomBorder)*/
        
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
