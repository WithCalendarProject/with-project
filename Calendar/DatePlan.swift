//
//  DatePlane.swift
//  Calendar
//
//  Created by 川村周也 on 2017/12/20.
//  Copyright © 2017年 川村周也. All rights reserved.
//

import UIKit
import RealmSwift

class DatePlan: Object {
    
    @objc dynamic var date = Date()
    @objc dynamic var plan = ""
    @objc dynamic var start = 0
    @objc dynamic var end = 0
    @objc dynamic var objectId = ""
}
