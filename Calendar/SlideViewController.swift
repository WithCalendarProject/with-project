//
//  SlideViewController.swift
//  Calendar
//
//  Created by 川村周也 on 2018/04/13.
//  Copyright © 2018年 川村周也. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideViewController: SlideMenuController {

    override func awakeFromNib() {
        let main = storyboard?.instantiateViewController(withIdentifier: "calendar")
        let left = storyboard?.instantiateViewController(withIdentifier: "home")
        
        mainViewController = main
        leftViewController = left
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.tabBarController?.tabBar.isTranslucent = false;
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
