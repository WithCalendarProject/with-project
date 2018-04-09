//
//  CalendarCell.swift
//  Collection
//
//  Created by 川村周也 on 2017/12/05.
//  Copyright © 2017年 川村周也. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var textLabel : UILabel!
    var dateLabel : UILabel!
    
    var ovalShapeLayer = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
    
        ovalShapeLayer.lineWidth = 1.0
        ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(x:10, y:10, width:30, height:30)).cgPath
        ovalShapeLayer.frame = self.bounds
        
        //UILabelを生成
        textLabel = UILabel(frame: CGRect(x:0, y:0, width:self.frame.width,  height: self.frame.height))
        textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        textLabel.textAlignment = NSTextAlignment.center
        /*
        dateLabel = UILabel(frame: CGRect(x:0, y:0, width:self.frame.width,  height: self.frame.height))
        dateLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        dateLabel.textAlignment = NSTextAlignment.center
 */
        
        // Cellに追加
        self.addSubview(textLabel!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
}
