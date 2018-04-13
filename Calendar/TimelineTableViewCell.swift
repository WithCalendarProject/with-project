//
//  TimelineTableViewCell.swift
//  Calendar
//
//  Created by 川村周也 on 2018/04/04.
//  Copyright © 2018年 川村周也. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var IconImage: UIImageView!
    @IBOutlet weak var PostDateLabel: UILabel!
    @IBOutlet weak var PlanLabel: UILabel!
    @IBOutlet weak var PlaseLabel: UILabel!
    @IBOutlet weak var ContentTextView: UITextView!
    @IBOutlet weak var PostImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
