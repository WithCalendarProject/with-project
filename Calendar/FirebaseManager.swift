//
//  FirebaseManager.swift
//  Calendar
//
//  Created by 川村周也 on 2018/02/25.
//  Copyright © 2018年 川村周也. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager: NSObject {
    
    let ref = Database.database().reference() //Firebaseのルートを宣言しておく
    let accountID = (Auth.auth().currentUser?.uid)!
    var myID = ""
    var contentArray: [DataSnapshot] = [] //Fetchしたデータを入れておく配列、この配列をTableViewで表示
    var array: [DataSnapshot] = []
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    var items:Dictionary<String, AnyObject> = [:]
    
    
    //C言語のポインタみたいにいくらこっちで値を変更しても元々の値は変わらない。
    func readDataFilterSingle(key: String...,filterType: String, sortKey: String,targetValue: Any, function: @escaping () -> ()) -> () {
        
        if filterType == "equalTo" {

            if(key.count == 1){
                ref.child("\(key[0])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEqual(toValue: "\(targetValue)")        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if (key.count == 2){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEqual(toValue: "\(targetValue)")        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if(key.count == 3){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .child("\(key[2])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEqual(toValue: "\(targetValue)")        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                    })
            }
        }else if filterType == "toFirst" {
            if(key.count == 1){
                ref.child("\(key[0])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)       // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if (key.count == 2){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if(key.count == 3){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .child("\(key[2])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                    })
            }
        }else if filterType == "toLast" {
            if(key.count == 1){
                ref.child("\(key[0])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if (key.count == 2){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if(key.count == 3){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .child("\(key[2])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                    })
            }
        }else if filterType == "startAt" {
            if(key.count == 1){
                ref.child("\(key[0])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryStarting(atValue: targetValue)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if (key.count == 2){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryStarting(atValue: targetValue)       // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if(key.count == 3){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .child("\(key[2])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryStarting(atValue: targetValue)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                    })
            }
        }else if filterType == "endAt" {
            if(key.count == 1){
                ref.child("\(key[0])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEnding(atValue: targetValue)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if (key.count == 2){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEnding(atValue: targetValue)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if(key.count == 3){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .child("\(key[2])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEnding(atValue: targetValue)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observeSingleEvent(of: .value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                    })
            }
        }
        
        print("content:\(contentArray)")
        
    }
    
    func readDataFilterObserve(key: String...,filterType: String, sortKey: String,targetValue: Any, function: @escaping () -> ()) -> () {
        
        if filterType == "equalTo" {
            
            if(key.count == 1){
                ref.child("\(key[0])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEqual(toValue: "\(targetValue)")        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if (key.count == 2){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEqual(toValue: "\(targetValue)")        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if(key.count == 3){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .child("\(key[2])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEqual(toValue: "\(targetValue)")        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                    })
            }
        }else if filterType == "toFirst" {
            if(key.count == 1){
                ref.child("\(key[0])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)       // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if (key.count == 2){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if(key.count == 3){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .child("\(key[2])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                    })
            }
        }else if filterType == "toLast" {
            if(key.count == 1){
                ref.child("\(key[0])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if (key.count == 2){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if(key.count == 3){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .child("\(key[2])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryLimited(toFirst: targetValue as! UInt)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                    })
            }
        }else if filterType == "startAt" {
            if(key.count == 1){
                ref.child("\(key[0])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryStarting(atValue: targetValue)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if (key.count == 2){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryStarting(atValue: targetValue)       // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if(key.count == 3){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .child("\(key[2])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryStarting(atValue: targetValue)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                    })
            }
        }else if filterType == "endAt" {
            if(key.count == 1){
                ref.child("\(key[0])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEnding(atValue: targetValue)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if (key.count == 2){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEnding(atValue: targetValue)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                        
                    })
            }else if(key.count == 3){
                
                ref.child("\(key[0])")
                    .child("\(key[1])")
                    .child("\(key[2])")
                    .queryOrdered(byChild: "\(sortKey)") // ソートキー
                    .queryEnding(atValue: targetValue)        // 値がtargetValueと同じものだけをfilterして取り出す
                    .observe(.value, with: {(snapShots) in
                        if snapShots.children.allObjects is [DataSnapshot] {
                            print("ManagerSnapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                            print("snapShot...\(snapShots)") //読み込んだデータをプリント
                            
                            self.snap = snapShots
                            
                        }
                        self.reload(snap: self.snap,function: function)
                    })
            }
        }
        
        print("content:\(contentArray)")
        
    }

    func readDataObserve(key: String..., function: @escaping () -> ()) -> () {
        if(key.count == 1){
            
            ref.child("\(key[0])")
                .observe(.value, with: {(snapShots) in
                    if snapShots.children.allObjects is [DataSnapshot] {
                        print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                        print("snapShot...\(snapShots)") //読み込んだデータをプリント
                        
                        self.snap = snapShots
                        
                    }
                    self.reload(snap: self.snap,function: function)
                })
        }else if (key.count == 2){
            
            ref.child("\(key[0])")
                .child("\(key[1])")
                .observe(.value, with: {(snapShots) in
                    if snapShots.children.allObjects is [DataSnapshot] {
                        print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                        print("snapShot...\(snapShots)") //読み込んだデータをプリント
                        
                        self.snap = snapShots
                        
                    }
                    self.reload(snap: self.snap,function: function)
                })
        }else if(key.count == 3){
            
            ref.child("\(key[0])")
                .child("\(key[1])")
                .child("\(key[2])")
                .observe(.value, with: {(snapShots) in
                    if snapShots.children.allObjects is [DataSnapshot] {
                        print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                        print("snapShot...\(snapShots)") //読み込んだデータをプリント
                        
                        self.snap = snapShots
                        
                    }
                    self.reload(snap: self.snap,function: function)
                })
        }
    }
    
    func readDataObserveSingleEvent(key: String..., function: @escaping () -> ()) -> () {
        
        if(key.count == 1){
            
            ref.child("\(key[0])")
                .observeSingleEvent(of: .value, with: { (snapShots) in
                    if snapShots.children.allObjects is [DataSnapshot] {
                        print("single:snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                        print("single:snapShot...\(snapShots)") //読み込んだデータをプリント
                        
                        self.snap = snapShots
                    }
                    self.reload(snap: self.snap,function: function)
                    
                })
        }else if (key.count == 2){
            
            ref.child("\(key[0])")
                .child("\(key[1])")
                .observeSingleEvent(of: .value, with: { (snapShots) in
                    if snapShots.children.allObjects is [DataSnapshot] {
                        print("single:snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                        print("single:snapShot...\(snapShots)") //読み込んだデータをプリント
                        
                        self.snap = snapShots
                    }
                    self.reload(snap: self.snap,function: function)
                })
        }else if(key.count == 3){
            
            ref.child("\(key[0])")
                .child("\(key[1])")
                .child("\(key[2])")
                .observeSingleEvent(of: .value, with: { (snapShots) in
                    if snapShots.children.allObjects is [DataSnapshot] {
                        print("single:snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                        print("single:snapShot...\(snapShots)") //読み込んだデータをプリント
                        
                        self.snap = snapShots
                    }
                    self.reload(snap: self.snap,function: function)
                })
        }
    }
    
    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func reload(snap: DataSnapshot,function: @escaping () -> ()) -> () {
        if snap.exists() {
            print(snap)
            //DataSnapshotが存在するか確認
            contentArray.removeAll()
            //1つになっているDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                contentArray.append(item as! DataSnapshot)
            }
            // ローカルのデータベースを更新
            ref.child((Auth.auth().currentUser?.uid)!).keepSynced(true)
            
            function()

        }else{
            contentArray.removeAll()
            
            function()
            
        }
    }
    
    
    
    func setValue(key: String...,value: [String: Any]) {
        
        if(key.count == 1){
            ref.child("\(key[0])").setValue(value)
        }else if(key.count == 2){
            ref.child("\(key[0])").child("\(key[1])").setValue(value)
        }else if(key.count == 3){
            ref.child("\(key[0])").child("\(key[1])").child("\(key[2])").setValue(value)
        }else if(key.count == 4){
            ref.child("\(key[0])").child("\(key[1])").child("\(key[2])").child("\(key[3])").setValue(value)
        }
        
    }
    
    func updateValue(key: String...,value: [String: Any]){
        
        if(key.count == 1){
            ref.child("\(key[0])").updateChildValues(value)
        }else if(key.count == 2){
            ref.child("\(key[0])").child("\(key[1])").updateChildValues(value)
        }else if(key.count == 3){
            ref.child("\(key[0])").child("\(key[1])").child("\(key[2])").updateChildValues(value)
        }else if(key.count == 4){
            ref.child("\(key[0])").child("\(key[1])").child("\(key[2])").child("\(key[3])").updateChildValues(value)
        }
        
    }
    
    func getMyID() -> String {
        
        readDataFilterSingle(key: "userList", "users",filterType: "equalTo", sortKey: "accountID", targetValue: accountID,function: {() -> () in
            
            let item = self.contentArray[0]
            let content = item.value as! Dictionary<String, AnyObject>
            
            self.myID = String(describing: content["userID"]!)
        })
        return self.myID
    }
}
