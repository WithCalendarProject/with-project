//
//  DateManager.swift
//  Collection
//
//  Created by 川村周也 on 2017/12/07.
//  Copyright © 2017年 川村周也. All rights reserved.
//

import UIKit

class DateManager: NSObject {

    var selectDay = Date()
    var biginDay = Date()
    var endDay = Date()
    let calendar = Calendar.current
    let date = Date()
    
    var days = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    func selectDate() -> Int{
        return calendar.component(.day,from: selectDay)
    }
    
    func selectMonth() -> Int{
        return calendar.component(.month,from: selectDay)
    }
    
    func selectYear() -> Int{
        return calendar.component(.year,from: selectDay)
    }
    
    func createCalendar(collection: UICollectionView) -> () {
        
        
        
    }
    
    
    //Dateから年月日を抽出する関数
    /*func roundDate(_ date: Date, calendar cal: Calendar) -> Date{
        return cal.date(from: DateComponents(year: cal.component(.year, from: date), month: cal.component(.month, from: date), day: cal.component(.day, from: date)))!
    }*/
    
    
    
    
    func BeginOfMonthCalender() -> Date{
        
        //日付の要素を1日にする
        var components = calendar.dateComponents([.year,.month,.day], from: selectDay)
        components.day = 1
        let firstOfMonth = Calendar.current.date(from: components)
        
        //曜日を調べて、その要素数だけ戻ったものがカレンダーの左上(日曜日=1 土曜日=7　なので1足した状態で戻る)
        let dayOfWeek = calendar.component(.weekday,from:firstOfMonth!)
        
        return calendar.date(byAdding: .day, value: 1-dayOfWeek, to: firstOfMonth!)!
    }
    
    func firstdayOfMonth() -> Date{
        // 月初
        let comps = calendar.dateComponents([.year, .month], from: selectDay)
        let firstday = calendar.date(from: comps)
        
        return firstday!
    }
    
    func lastdayOfMonth() -> Date{
        // 月末
        let add = DateComponents(month: 1, day: -1)
        let lastday = calendar.date(byAdding: add, to: firstdayOfMonth())
        
        return lastday!
    }
    
    func firstdayOfWeek() -> Int{
        return calendar.component(.weekday,from: firstdayOfMonth())
    }
    
    func lastdayOfWeek() -> Int{
        return calendar.component(.weekday,from: lastdayOfMonth())
    }
    
    //月カレンダーの終点になる日を求める
    func EndOfMonthCalendar() ->Date{
        
        let lastday = lastdayOfMonth()
        
        //次の月初めを取得
        let nextmonth = calendar.nextDate(after: selectDay, matching: DateComponents(day:1), matchingPolicy: Calendar.MatchingPolicy.nextTime)
        
        //曜日を調べて、その要素数だけ進んだものが右下(次の月の初めで計算している事に注意)
        let dayOfWeek = calendar.component(.weekday,from: lastday)
        
        return calendar.date(byAdding: .day, value: 7-dayOfWeek, to: nextmonth!)!
    }
    
    func daysAcquisition() -> Int{
        
        //始まりの日と終わりの日を取得
        biginDay = BeginOfMonthCalender()
        endDay = EndOfMonthCalendar()
        
        let sdayOfWeek = calendar.component(.weekday,from: firstdayOfMonth())
        let edayOfWeek = calendar.component(.weekday,from: lastdayOfMonth())
        
        let month = calendar.component(.month, from: selectDay)
        
        if calendar.component(.year, from: selectDay) % 4 == 0{
            days[1] = 29
        }else{
            days[1] = 28
        }
        
        //始点から終点の日数
        return days[month-1] + (sdayOfWeek-1) + (7-edayOfWeek)
    }
    
    //カレンダーの始点から指定した日数を加算した日付を返す
    func conversionDateFormat(index: Int)->String{
        
        let currentday = calendar.date(byAdding: .day, value: index, to: biginDay)
        
        return calendar.component(.day, from: currentday!).description
    }
    
    
    
    //今セレクトされているselectDayの年月をテキストで出力
    func CalendarHeader()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年　MM月"
        
        return formatter.string(from: selectDay)
    }
    
    func formatSelect()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd"
        
        return formatter.string(from: selectDay)
    }
    
    
    /*
     表示月を変える操作
     */
    
    //SelectDayを一ヶ月戻す
    func preMonthCalendar(){
        selectDay = calendar.date(byAdding: .month, value: -1, to: selectDay)!
    }
    
    
    
    //SelectDayを1か月進ませる
    func nextMonthCalendar(){
        selectDay = calendar.date(byAdding: .month, value: 1, to: selectDay)!
    }
    
    
    //SelectDayを1日戻す
    func preDayCalendar(){
        selectDay = calendar.date(byAdding: .day, value: -1, to: selectDay)!
    }
    
    //SelectDayを1日進む
    func nextDayCalendar(){
        selectDay = calendar.date(byAdding: .day, value: 1, to: selectDay)!
    }
    
    func tapDayCalendar(){
        selectDay = calendar.date(byAdding: .day, value: selected+1, to: biginDay-1)!
    }
    
    
    
    
    
}
