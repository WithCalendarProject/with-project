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
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    //var userListSnap: DataSnapshot! //FetchしたSnapshotsを格納する変数
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
        
        firebaseManager.readDataFilterSingle(key: "userList", "users", filterType: "endAt", sortKey: "userNumber", targetValue: 1,function: {() -> () in
            //配列の該当のデータをitemという定数に代入
            let item = self.firebaseManager.contentArray[0]
            //itemの中身を辞書型に変換
            let content = item.value as! Dictionary<String, AnyObject>
            self.userNumber = content["userNumber"] as! Int + 1
            
            self.firebaseManager.setValue(key: "userList","users", "user\(self.userNumber)",value: ["userID": userID,"accountID": (Auth.auth().currentUser?.uid)!,"userName": userName,"coment": coment,"userNumber": "\(self.userNumber)"])
        })
        
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
            .child("userInfomation")
            .updateChildValues(["user":(Auth.auth().currentUser?.uid)!,"userName": self.NameTextField.text!,"userID": self.IDTextField.text!,"coment": self.ComentTextField.text!])
        
        firebaseManager.readDataObserveSingleEvent(key: "userList", "users", function: {() -> () in
            
            self.userNumber = self.firebaseManager.contentArray.count+1
            
            self.firebaseManager.updateValue(key: "userList","users","user\(self.userNumber)", value: ["userID": self.IDTextField.text!,"accountID": (Auth.auth().currentUser?.uid)!,"userName": self.NameTextField.text!,"coment": self.ComentTextField.text!, "userNumber": self.userNumber])
            
        })
    }
    
    func read()  {
        //DataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        
        firebaseManager.readDataObserve(key: (Auth.auth().currentUser?.uid)!,"userInfomation", function: {() -> () in
            if !self.firebaseManager.contentArray.isEmpty {
            //配列の該当のデータをitemという定数に代入
            let item = self.firebaseManager.contentArray[0]
            //itemの中身を辞書型に変換
            let content = item.value as! Dictionary<String, AnyObject>
            self.NameLabel.text = String(describing: content["userName"]!)
            self.IDLabel.text = String(describing: content["userID"]!)
            self.ComentLabel.text = String(describing: content["coment"]!)
            }
            
        })
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NameTextField.delegate = self
        IDTextField.delegate = self
        ComentTextField.delegate = self
        
        //self.read()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.read()
        
        firebaseManager.readDataFilterSingle(key: "userList", "users", filterType: "endAt", sortKey: "userNumber", targetValue: 1,function: {() -> () in
            //配列の該当のデータをitemという定数に代入
            let item = self.firebaseManager.contentArray[0]
            //itemの中身を辞書型に変換
            let content = item.value as! Dictionary<String, AnyObject>
            self.userNumber = content["userNumber"] as! Int + 1
            print("user: \(self.userNumber)")
        })
        
        
        firebaseManager.readDataFilterSingle(key: "userList", "users",filterType: "equalTo", sortKey: "accountID", targetValue: (Auth.auth().currentUser?.uid)!, function: {() -> () in
            if !self.firebaseManager.contentArray.isEmpty {
            let item = self.firebaseManager.contentArray[0]
            let content = item.value as! Dictionary<String, AnyObject>
            
            self.myID = String(describing: content["userID"]!)
            self.myNumber = String(describing: content["userNumber"]!)
            }
        })
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
