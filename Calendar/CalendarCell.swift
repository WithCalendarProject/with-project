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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        
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
