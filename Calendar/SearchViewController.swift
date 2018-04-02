//
//  SearchViewController.swift
//  
//
//  Created by 川村周也 on 2018/02/22.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{
    
    var searchText: String = ""
    let ref = Database.database().reference() //FirebaseDatabaseのルートを指定
    let firebaseManager = FirebaseManager()
    var myID = ""

    @IBOutlet weak var searchCondition: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultTable: UITableView!
    @IBAction func searchButton(_ sender: Any) {
        searchText = searchTextField.text!
        
        print (searchText)
        
        firebaseManager.readDataFilterSingle(key: "userList", "users", filterType: "equalTo", sortKey: "userID", targetValue: "\(searchText)", function: {() -> () in
            self.resultTable.reloadData()
        })
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    
    @IBAction func tapView(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        firebaseManager.readDataFilterSingle(key: "userList", "users", filterType: "equalTo", sortKey: "accountID", targetValue: firebaseManager.accountID, function: {() -> () in
            let item = self.firebaseManager.contentArray[0]
            let content = item.value as! Dictionary<String, AnyObject>
            
            self.myID = String(describing: content["userID"]!)
            
        })
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        searchTextField.delegate = self
        resultTable.delegate = self
        resultTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {//セルの数　＝　検索結果の数
        return firebaseManager.contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        //配列の該当のデータをitemという定数に代入
        let item = firebaseManager.contentArray[indexPath.row]
        
        //itemの中身を辞書型に変換
        let content = item.value as! Dictionary<String, AnyObject>
        
        cell.textLabel?.text = String(describing: content["userID"]!)
       
        return cell
    }
    
    //予定の更新処理
    //選択されたCellの番号を引数に取り、contentArrayからその番号の値を取り出し、selectedSnapに代入
    //その後遷移
    func didSelectRow(selectedIndexPath indexPath: IndexPath) {
        //ルートからのchildをユーザーのIDに指定
        //ユーザーIDからのchildを選択されたCellのデータのIDに指定
        
        //userInfo使ってないからここでエラーが出る。
        
        firebaseManager.readDataFilterSingle(key: "userList", "users", filterType: "equalTo", sortKey: "userID", targetValue: "\(searchText)", function: {() -> () in
            
            let items = self.firebaseManager.contentArray[indexPath.row]
            let content = items.value as! Dictionary<String, AnyObject>
            
            let alert = UIAlertController(title: "\(String(describing: content["userName"]!))", message: "\(String(describing: content["userID"]!))\n\(String(describing: content["coment"]!))", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "フォロー", style: .default, handler: {action in
                
                //フォローの追加
                self.firebaseManager.setValue(key: "friends","following","\(self.myID)","users", value: ["\(String(describing: content["userID"]!))": "\(String(describing: content["accountID"]!))"])
                
                //フォロワーの追加
                self.firebaseManager.setValue(key: "friends","follower","\(String(describing: content["userID"]!))","users", value: ["\(self.myID)": self.firebaseManager.accountID])
                
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
            self.present(alert, animated: true, completion: nil)
            
        })
       
    }
    
    //Cellがタップされると呼ばれる
    //上記のdidSelectedRowにタップされたCellのIndexPathを渡す
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRow(selectedIndexPath: indexPath)
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
