//
//  ViewController.swift
//  Collection
//
//  Created by 川村周也 on 2017/12/04.
//  Copyright © 2017年 川村周也. All rights reserved.
//

// MARK: 予定をテーブルビューに表示させる

import UIKit
import Firebase

//var selected =  Calendar.current.component(.day, from: Date())
var selected = 0
var selectedColor: UIColor = UIColor.black

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var kindOfCalendar: UILabel!
    
    @IBAction func prevMonthBtn(_ sender: UIButton) {
        
        dateManager.preMonthCalendar()
        datePlanTable.isHidden = true
        selectedColor = UIColor.black
        self.read()
        headerTitle.text = dateManager.CalendarHeader()
        
    }

    @IBAction func nextMonthBtn(_ sender: UIButton) {

        dateManager.nextMonthCalendar()
        datePlanTable.isHidden = true
        selectedColor = UIColor.black
        self.read()
        headerTitle.text = dateManager.CalendarHeader()
        
    }
    
    
    let dateManager = DateManager()
    let firebaseManager = FirebaseManager()
    let weeks = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    let cellMargin : CGFloat = 2.0  //セルのマージン。セルのアイテムのマージンも別にあって紛らわしい。アイテムのマージンはゼロに設定し直してる
    var cellVerticalMargin : CGFloat = 0.0
    var cellRect = CGRect(x: 0,y: 0,width: 0,height: 0)
    
    //var datePlans: [DataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    var items:Dictionary<String, AnyObject> = [:]
    
    let ref = Database.database().reference() //Firebaseのルートを宣言しておく
    
    //変更したいデータのための変数、CellがタップされるとselectedSnapに値が代入される
    var selectedSnap: DataSnapshot!
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    //テーブルビューのインスタンス作成
    var datePlanTable: UITableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedColor = UIColor.black
        datePlanTable.isHidden = true
        calendarCollectionView.reloadData()
        
        //テーブルビュー初期化、関連付け
        datePlanTable.frame = CGRect(x: 0,y: cellRect.minY + cellRect.height,width: self.view.frame.width,height: 150);
        datePlanTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.calendarCollectionView.addSubview(datePlanTable)
        
        //データを読み込むためのメソッド
        self.read()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        ref.removeAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        datePlanTable.delegate = self
        datePlanTable.dataSource = self
        
        //データを読み込むためのメソッド
        self.read()

        headerTitle.text = dateManager.CalendarHeader()  //追加
        headerTitle.sizeToFit()
        
        
    }
    
    func read()  {
        /*
        firebaseManager.readDataNomal(sortKey: "date", targetValue: "\(dateManager.formatSelect())", key: "datePlans","\(firebaseManager.accountID)")*/
        
        firebaseManager.readDataFilterSingle(key: (Auth.auth().currentUser?.uid)!,"datePlans", filterType: "equalTo", sortKey: "date", targetValue: dateManager.formatSelect(), function: {() -> () in
            //テーブルビューをリロード
            self.datePlanTable.reloadData()
        })
        
        calendarCollectionView.reloadData()
    }
    
    //InputViewControllerへの遷移
    func transition() {
        self.performSegue(withIdentifier: "toInput", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セル数を返却
        return firebaseManager.contentArray.count //ここを０にするとセルが表示されない。
    }
    
    // MARK: 予定をテーブルビューに表示させる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        //配列の該当のデータをitemという定数に代入
        let item = firebaseManager.contentArray[indexPath.row]
        //itemの中身を辞書型に変換
        let content = item.value as! Dictionary<String, AnyObject>
        //dateという添字で保存していた日付をdateという定数に代入
        let date = content["date"]
        
        //contentという添字で保存していた投稿内容を表示
        
        if(String(describing: date!) == dateManager.formatSelect()){
        cell.textLabel?.text = String(describing: content["plan"]!) + "   " + String(describing: date!)
        }
        // itemNameをセルに表示
        //cell.textLabel?.text = myItems[indexPath.row].plan + "  " + myItems[indexPath.row].plase
        return cell
    }
    
  //予定の更新処理
    //選択されたCellの番号を引数に取り、contentArrayからその番号の値を取り出し、selectedSnapに代入
    //その後遷移
    func didSelectRow(selectedIndexPath indexPath: IndexPath) {
        //ルートからのchildをユーザーのIDに指定
        //ユーザーIDからのchildを選択されたCellのデータのIDに指定
        self.selectedSnap = firebaseManager.contentArray[indexPath.row]
        self.transition()
    }
    //Cellがタップされると呼ばれる
    //上記のdidSelectedRowにタップされたCellのIndexPathを渡す
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRow(selectedIndexPath: indexPath)
    }
    
    
    //予定の削除処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
            //デリートボタンを追加
            if editingStyle == .delete {
                //選択されたCellのNSIndexPathを渡し、データをFirebase上から削除するためのメソッド
                self.delete(deleteIndexPath: indexPath)
                //TableView上から削除
                datePlanTable.deleteRows(at: [indexPath as IndexPath], with: .fade)
            }
    }
    
    func delete(deleteIndexPath indexPath: IndexPath) {
        ref.child((Auth.auth().currentUser?.uid)!).child("datePlans").child(firebaseManager.contentArray[indexPath.row].key).removeValue()
        firebaseManager.contentArray.remove(at: indexPath.row)
    }
    
    
   /* //上スワイプで次の月へ
    @IBAction func swipedUp(_ sender: UISwipeGestureRecognizer) {
        dateManager.nextMonthCalendar()
        calendarCollectionView.reloadData()
        //データを読み込むためのメソッド
        self.read()
        headerTitle.text = dateManager.CalendarHeader()
    }*/
   /*
    @IBAction func downSwiped(_ sender: UISwipeGestureRecognizer) {
        dateManager.preMonthCalendar()
        calendarCollectionView.reloadData()
        //データを読み込むためのメソッド
        self.read()
        headerTitle.text = dateManager.CalendarHeader()
    }*/
    
    /*
     
     セルのレイアウト設定
     
     */
    //セルサイズの指定（UICollectionViewDelegateFlowLayoutで必須）　横幅いっぱいにセルが広がるようにしたい
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin:CGFloat = 8.0
        let widths:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin)/CGFloat(7)
        let heights:CGFloat = widths * 0.8
        
        return CGSize(width:widths,height:heights)
    }
    
    //セルのアイテムのマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0 , 0.0 , 0.0 , 0.0 )  //マージン(top , left , bottom , right)
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellVerticalMargin
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // "Cell" はストーリーボードで設定したセルのID
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath) as! CalendarCell
        
        //cell.ovalShapeLayer.delegate = self as? CALayerDelegate
        cell.ovalShapeLayer.removeFromSuperlayer()
        //cell.textLabel.font = UIFont.boldSystemFont(ofSize: 12)

        if (indexPath.item % 7 == 0) {
            cell.textLabel.textColor = UIColor.red
        } else if (indexPath.item % 7 == 6) {
            cell.textLabel.textColor = UIColor.blue
        } else {
            cell.textLabel.textColor = UIColor.black
        }
        
        if(indexPath.section == 0){             //曜日表示
            cell.backgroundColor = UIColor.clear
            cell.textLabel.font = UIFont.systemFont(ofSize: 12)
            cell.textLabel.text = weeks[indexPath.row]
            
        }else{                                  //日付表示
            cell.backgroundColor = UIColor.clear
            
            cell.textLabel.text = dateManager.conversionDateFormat(index: indexPath.row) //Index番号から表示する日を求める
            cell.tag = Int(dateManager.conversionDateFormat(index: indexPath.row))!//セルのタグに日付を追加
            
            /*
            if judgePlanIsEnpty(year: dateManager.selectYear(), month: dateManager.selectMonth(), day: cell.tag, dates: dates) == false{
                //cell.textLabel.text = cell.textLabel.text! + "."
            }*/
            
            if indexPath.item - dateManager.firstdayOfWeek() + 2  == dateManager.selectDate(){
                //cell.textLabel.textColor = selectedColor
                cell.textLabel.textColor = UIColor.white
                cell.textLabel.font = UIFont.boldSystemFont(ofSize: 12)
                cellRect = cell.frame
                print(cellRect)
                datePlanTable.frame = CGRect(x: 0,y: cellRect.minY + CGFloat(cellRect.height),width: self.view.frame.width,height: 150)
                cell.ovalShapeLayer.strokeColor = UIColor.cyan.cgColor  // 輪郭は青
                cell.ovalShapeLayer.fillColor = UIColor.cyan.cgColor  // 塗りはクリア
                cell.layer.insertSublayer(cell.ovalShapeLayer, at: 0)
            }else{
                cell.textLabel.font = UIFont.systemFont(ofSize: 12)
            }
            
            if indexPath.item < dateManager.firstdayOfWeek()-1{
                cell.textLabel.text = ""
            }
            if indexPath.item > dateManager.daysAcquisition()-(8-dateManager.lastdayOfWeek()){
                cell.textLabel.text = ""
            }
            
            
        }
        
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // section数は2つ
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0){   //section:0は曜日を表示
            return 7
        }else{
            return dateManager.daysAcquisition()        //section:1は日付を表示 　※セルの数は始点から終点までの日数
        }
    }
    
    /*//データの中から引数で指定された日にちがなかったらtrueを返す関数
    func judgePlanIsEnpty(year: Int, month: Int, day: Int, dates: Array<Any>) -> Bool{
        
        //let date = String(format: "%04d",year) + "/" + String(format: "%02d",month) + "/" + String(format: "%02d",day)
        /*
        let datePlanObj = realm.objects(DatePlan.self).filter("date == %@", date)
        
        myItems = []
        datePlanObj.forEach { item in
            myItems.append(item)
        }*/
        
        if dates.isEmpty == true{
            return true
        }else {
            return false
        }
 
    }*/
    
    //セルが選択された時の処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
        if indexPath.item < dateManager.firstdayOfWeek()-1{
            return
        }
        if indexPath.item > dateManager.daysAcquisition()-(8-dateManager.lastdayOfWeek()){
            return
        }
        
        if selected == indexPath.item, selectedColor == UIColor.white{
            selectedColor = UIColor.black
            calendarCollectionView.collectionViewLayout.invalidateLayout()
            //その位置までスクロールする
            calendarCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
            datePlanTable.isHidden = true
        }else{
            selectedColor = UIColor.white
            selected = indexPath.item
            calendarCollectionView.collectionViewLayout.invalidateLayout()
            datePlanTable.isHidden = false
            //calendarCollectionView.setContentOffset(CGPoint(x:0,y:40 * (selected/7)), animated: true)
        }
        dateManager.tapDayCalendar()
        
        calendarCollectionView.reloadData()
        
        headerTitle.text = dateManager.CalendarHeader()//ヘッダを選択された日づけにする
        print(dateManager.formatSelect())
        print(indexPath.item % 7 - (indexPath.item - selected))
        collectionView.deselectItem(at: indexPath, animated: true)
            
        //データを読み込むためのメソッド
        self.read()
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //segue間で値を渡すメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toInput"{
            let thatDay = dateManager.formatSelect()
            let view = segue.destination as! InputViewController
            if let snap = self.selectedSnap {
                view.selectedSnap = snap
            }
            (segue.destination as! InputViewController).thatDay = thatDay
        }
    }
}

