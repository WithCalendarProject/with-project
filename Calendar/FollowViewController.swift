//
//  FollowViewController.swift
//  Calendar
//
//  Created by 川村周也 on 2018/02/25.
//  Copyright © 2018年 川村周也. All rights reserved.
//

import UIKit
import Firebase

class NavigationBar: UINavigationBar {
    /*
    let navBarBorder = UIView()
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var barSize = super.sizeThatFits(size)
        barSize.height = 51 // new height
        return barSize;
    }*/
}

class FollowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let firebaseManager = FirebaseManager()
    var myID = ""
    
    @IBOutlet weak var followTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseManager.contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        //配列の該当のデータをitemという定数に代入
        let item = firebaseManager.contentArray[indexPath.row]
        //itemの中身を辞書型に変換
        let content = item.value as! Dictionary<String, AnyObject>
        
        let key = Array(content.keys)
        
        cell.textLabel?.text = key[0]
        
        // itemNameをセルに表示
        //cell.textLabel?.text = myItems[indexPath.row].plan + "  " + myItems[indexPath.row].plase
        return cell
    }
    
    func read()  {
        /*
         firebaseManager.readDataNomal(sortKey: "date", targetValue: "\(dateManager.formatSelect())", key: "datePlans","\(firebaseManager.accountID)")*/
        
        firebaseManager.readDataObserve(key: "friends","following","\(self.myID)", function: {() -> () in
            //テーブルビューをリロード
            self.followTable.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        firebaseManager.readDataFilterSingle(key: "userList", "users",filterType: "equalTo", sortKey: "accountID", targetValue: firebaseManager.accountID, function: {() -> () in
            
            let item = self.firebaseManager.contentArray[0]
            let content = item.value as! Dictionary<String, AnyObject>
            
            self.myID = String(describing: content["userID"]!)
            
            self.firebaseManager.readDataObserve(key: "friends","following","\(self.myID)", function: {() -> () in
                //テーブルビューをリロード
                self.followTable.reloadData()
            })
        })
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        followTable.delegate = self
        followTable.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //ここにフォローを外した時の削除処理を書く
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
