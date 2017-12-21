//
//  ViewController.swift
//  Collection
//
//  Created by 川村周也 on 2017/12/04.
//  Copyright © 2017年 川村周也. All rights reserved.
//

import UIKit
import RealmSwift

var selected = 0

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBAction func prevMonthBtn(_ sender: UIButton) {
        
        dateManager.preMonthCalendar()
        calendarCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
        
    }
    @IBAction func prevDayBtn(_ sender: UIButton) {
        
        dateManager.preDayCalendar()
        calendarCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
        
    }
    @IBAction func nextMonthBtn(_ sender: UIButton) {
        
        dateManager.nextMonthCalendar()
        calendarCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
        
    }
    @IBAction func nextDayBtn(_ sender: UIButton) {
        
        dateManager.nextDayCalendar()
        calendarCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
        
    }
    
    let realm = try! Realm()
    
    let dateManager = DateManager()
    let layout = UICollectionViewFlowLayout()
    
    let weeks = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    
    var cellWidth:CGFloat = 0.0
    var cellHeight:CGFloat = 0.0
    let cellMargin : CGFloat = 2.0  //セルのマージン。セルのアイテムのマージンも別にあって紛らわしい。アイテムのマージンはゼロに設定し直してる
    
    
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        headerTitle.text = dateManager.CalendarHeader()  //追加
        
        
    }
    
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
        return cellMargin
    }

    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        cellWidth = view.frame.width/7 - 2
        cellHeight = cellWidth/2
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellWidth, height: cellHeight)
    }*/
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // "Cell" はストーリーボードで設定したセルのID
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath) as! CalendarCell

        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.red
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.blue
        } else {
            cell.textLabel.textColor = UIColor.black
        }
        
        if(indexPath.section == 0){             //曜日表示
            cell.backgroundColor = UIColor.clear
            cell.textLabel.text = weeks[indexPath.row]
            
        }else{                                  //日付表示
            cell.backgroundColor = UIColor.clear
            cell.textLabel.text = dateManager.conversionDateFormat(index: indexPath.row) //Index番号から表示する日を求める
            
            if indexPath.row - dateManager.firstdayOfWeek() + 2  == dateManager.selectDate(){
                cell.textLabel.textColor = UIColor.white
            }
            
            if indexPath.row < dateManager.firstdayOfWeek()-1{
                cell.textLabel.text = ""
            }
            if indexPath.row > dateManager.daysAcquisition()-(8-dateManager.lastdayOfWeek()){
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
    
    //選択されたセルの日付を出力する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.row
        dateManager.tapDayCalendar()
        calendarCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
        print(dateManager.selectDay)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func selection() -> Int{
        return selected
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

