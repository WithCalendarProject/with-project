//
//  InputViewController.swift
//  Calendar
//
//  Created by 川村周也 on 2017/12/20.
//  Copyright © 2017年 川村周也. All rights reserved.
//

import UIKit
import Firebase

class InputViewController: UIViewController, UITextFieldDelegate{
    
    let dateManager = DateManager()
    var thatDay: String?
    let calendar = Calendar.current
    
    let ref = Database.database().reference() //FirebaseDatabaseのルートを指定
    
    var isCreate = true //データの作成か更新かを判定、trueなら作成、falseなら更新
    
    var selectedSnap: DataSnapshot! //ListViewControllerからのデータの受け取りのための変数

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var plaseTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //selectedSnapがnilならその後の処理をしない
        guard let snap = self.selectedSnap else { return }
        
        //受け取ったselectedSnapを辞書型に変換
        let item = snap.value as! Dictionary<String, AnyObject>
        //textFieldに受け取ったデータのcontentを表示
        textField.text = item["plan"] as? String
        plaseTextField.text = item["plase"] as? String
        //isCreateをfalseにし、更新するためであることを明示
        isCreate = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        plaseTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    
    @IBAction func tapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func createBtn(_ sender: Any) {
        
        if isCreate {
            //投稿のためのメソッド
            create()
        }else {
            //更新するためのメソッド
            update()
        }
        // 前の画面に戻る処理を作成
        dismiss(animated: true, completion: nil)
        
    }
        
        //データの送信のメソッド
        func create() {
            //textFieldになにも書かれてない場合は、その後の処理をしない
            guard let plan = textField.text else{return}
            let plase = plaseTextField.text!
            
            //ロートからログインしているユーザーのIDをchildにしてデータを作成
            //childByAutoId()でユーザーIDの下に、IDを自動生成してその中にデータを入れる
            //setValueでデータを送信する。第一引数に送信したいデータを辞書型で入れる
            //今回は記入内容と一緒にユーザーIDと時間を入れる
            //FIRServerValue.timestamp()で現在時間を取る
            
            if plan != ""{
                self.ref.child((Auth.auth().currentUser?.uid)!)
                    .child("datePlans")
                    .childByAutoId()
                    .setValue(["user": (Auth.auth().currentUser?.uid)!,"plan": plan, "plase": plase, "date": thatDay])
            }
        }
    
    //更新のためのメソッド
    func update() {
        //ルートからのchildをユーザーIDに指定
        //ユーザーIDからのchildを受け取ったデータのIDに指定
        //updateChildValueを使って更新
        ref.keepSynced(true)
        ref.child((Auth.auth().currentUser?.uid)!)
            .child("datePlans")
            .child("\(self.selectedSnap.key)")
            .updateChildValues(["user": (Auth.auth().currentUser?.uid)!,"plan": self.textField.text!, "plase": self.plaseTextField.text!,"date": thatDay!])
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
