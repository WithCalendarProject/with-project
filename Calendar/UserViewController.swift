//
//  UserViewController.swift
//  Calendar
//
//  Created by 川村周也 on 2018/02/22.
//  Copyright © 2018年 川村周也. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController, UITextFieldDelegate{
    
    let ref = Database.database().reference() //FirebaseDatabaseのルートを指定
    let firebaseManager = FirebaseManager()
    var userInfo: [DataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var myInfo: [DataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    var userListSnap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    var items:Dictionary<String, AnyObject> = [:]
    var isCreate = false //データの作成か更新かを判定、trueなら作成、falseなら更新
    var userNumber = 0
    var myID = ""
    var myNumber = ""

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var ComentLabel: UILabel!
    @IBOutlet weak var ComentTextField: UITextField!
    @IBOutlet weak var Edit: UIButton!
    @IBOutlet weak var decide: UIButton!
    
    @IBAction func EditButton(_ sender: Any) {
        
        NameTextField.text = NameLabel.text
        IDTextField.text = IDLabel.text
        ComentTextField.text = ComentLabel.text
        
        //各ラベルが初期状態でなかったら更新モード
        if NameLabel.text! == "Name",IDLabel.text! == "ID",ComentLabel.text!  == "coment"{
            print("processed")
            isCreate = true
        }else{
            isCreate = false
        }
        
        NameLabel.isHidden = true
        IDLabel.isHidden = true
        ComentLabel.isHidden = true
        NameTextField.isHidden = false
        IDTextField.isHidden = false
        ComentTextField.isHidden = false
        Edit.isHidden = true
        Edit.isEnabled = false
        decide.isHidden = false
        decide.isEnabled = true
        
    }
    
    @IBAction func DecideButton(_ sender: Any) {
        
        if isCreate {
            print("created")
            //投稿のためのメソッド
            create()
        }else {
            //更新するためのメソッド
            update()
        }
        
        NameLabel.isHidden = false
        IDLabel.isHidden = false
        ComentLabel.isHidden = false
        NameTextField.isHidden = true
        IDTextField.isHidden = true
        ComentTextField.isHidden = true
        Edit.isHidden = false
        Edit.isEnabled = true
        decide.isHidden = true
        decide.isEnabled = false
        
        // 前の画面に戻る処理を作成
        dismiss(animated: true, completion: nil)
        
    }
    
    //データの送信のメソッド
    func create() {
        
        //textFieldに何も書かれていない場合は、その後の処理をしない
        guard let userName = NameTextField.text else{return}
        let userID = IDTextField.text!
        let coment = ComentTextField.text!
        
        firebaseManager.readDataNomal(function: {() -> () in
            
            print(self.firebaseManager.contentArray.count)
            
            self.firebaseManager.setValue(key: "userList","users", "user\(self.firebaseManager.contentArray.count+1)",value: ["userID": userID,"accountID": (Auth.auth().currentUser?.uid)!,"userName": userName,"coment": coment,"userNumber": "\(self.firebaseManager.contentArray.count+1)"])
            
        }, key: "userList","users")
        
        
        firebaseManager.setValue(key: (Auth.auth().currentUser?.uid)!, "userInfomation","userInfomation" ,value: ["user":(Auth.auth().currentUser?.uid)!,"userName": userName,"userID": userID,"coment": coment])
        
    }
    
    //更新のためのメソッド
    func update() {
        //ルートからのchildをユーザーIDに指定
        //ユーザーIDからのchildを受け取ったデータのIDに指定
        //updateChildValueを使って更新
        ref.keepSynced(true)
        ref.child((Auth.auth().currentUser?.uid)!)
            .child("userInfomation")
            .child("\(self.snap.key)")
            .updateChildValues(["user":(Auth.auth().currentUser?.uid)!,"userName": self.NameTextField.text!,"userID": self.IDTextField.text!,"coment": self.ComentTextField.text!])
        
        firebaseManager.readDataNomal(function: {() -> () in
            
            self.userNumber = self.firebaseManager.contentArray.count+1
                
            self.firebaseManager.updateValue(key: "userList","users","user\(self.userNumber)", value: ["userID": self.IDTextField.text!,"accountID": (Auth.auth().currentUser?.uid)!,"userName": self.NameTextField.text!,"coment": self.ComentTextField.text!, "userNumber": self.userNumber])
            
        }, key: "userList", "users")
        
    }
    
    func read()  {
        //DataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        ref.child((Auth.auth().currentUser?.uid)!)
            .child("userInfomation")//これのせいで更新ができてない
            .observe(.value, with: {(snapShots) in
                if snapShots.children.allObjects is [DataSnapshot] {
                    print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                    
                    print("snapShot...\(snapShots)") //読み込んだデータをプリント
                    
                    self.snap = snapShots
                    
                }
                self.reload(snap: self.snap)
            })
        
        ref.child("userList")
            .observe(.value, with: {(snapShots) in
                if snapShots.children.allObjects is [DataSnapshot] {
                    print("userListSnap.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                    
                    print("snapShot...\(snapShots)") //読み込んだデータをプリント
                    
                    self.userListSnap = snapShots
                    
                }
                self.userReload(snap: self.userListSnap)
            })
    }
    
    func reload(snap: DataSnapshot) {
        if snap.exists() {
            print(snap)
            //DataSnapshotが存在するか確認
            userInfo.removeAll()
            //1つになっているDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                userInfo.append(item as! DataSnapshot)
            }
            //配列の該当のデータをitemという定数に代入
            let item = userInfo[0]
            //itemの中身を辞書型に変換
            let content = item.value as! Dictionary<String, AnyObject>
            //
            NameLabel.text = String(describing: content["userName"]!)
            IDLabel.text = String(describing: content["userID"]!)
            ComentLabel.text = String(describing: content["coment"]!)
            
            // ローカルのデータベースを更新
            ref.child((Auth.auth().currentUser?.uid)!).keepSynced(true)
        }else{
            userInfo.removeAll()
        }
    }
    
    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func userReload(snap: DataSnapshot) {
        if snap.exists() {
            print(snap)
            userNumber = Int(snap.childrenCount)
            // ローカルのデータベースを更新
            ref.child("userList").keepSynced(true)
        }else{
            userInfo.removeAll()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NameTextField.delegate = self
        IDTextField.delegate = self
        ComentTextField.delegate = self
        
        self.read()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ref.child("userList")
            .child("users")
            .queryOrdered(byChild: "accountID")
            .queryEqual(toValue: (Auth.auth().currentUser?.uid)!)
            .observe(.value, with: {(snapShots) in
                if snapShots.children.allObjects is [DataSnapshot] {
                    print("+snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                    
                    print("snapShot...\(snapShots)") //読み込んだデータをプリント
                    
                    self.userListSnap = snapShots
                    
                }
                if self.userListSnap.exists() {
                    print(self.userListSnap)
                    //DataSnapshotが存在するか確認
                    self.myInfo.removeAll()
                    //1つになっているDataSnapshotを分割し、配列に入れる
                    for item in self.userListSnap.children {
                        self.myInfo.append(item as! DataSnapshot)
                    }
                    print(self.myInfo.count)
                    let item = self.myInfo[0]
                    let content = item.value as! Dictionary<String, AnyObject>
                    
                    self.myID = String(describing: content["userID"]!)
                    self.myNumber = String(describing: content["userNumber"]!)
                    // ローカルのデータベースを更新
                    self.ref.child((Auth.auth().currentUser?.uid)!).keepSynced(true)
                }else{
                    self.myInfo.removeAll()
                }
            })
        
            self.read()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        ref.removeAllObservers()
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
