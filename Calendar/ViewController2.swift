//
//  ViewController2.swift
//  Calendar
//
//  Created by 川村周也 on 2017/12/20.
//  Copyright © 2017年 川村周也. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController2: UIViewController, UITextFieldDelegate{
    
    let dateManager = DateManager()

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createBtn(_ sender: Any) {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let datePlan = DatePlan()
        datePlan.plan = textField.text!
        datePlan.date = dateManager.selectDay
        try! realm.write {
            realm.add(datePlan)
        }
        let Data = realm.objects(DatePlan.self)
        print(Data)
        self.dismiss(animated: true, completion: nil)
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
