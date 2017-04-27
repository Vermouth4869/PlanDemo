//
//  HelpViewController.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    var scrollV = HelpScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "HELP"
        self.view.backgroundColor = UIColor.white
        
        initScrollV()
    
    }
    
    func initScrollV() {
        
        let nameArray = ["sakura0", "sakura1", "sakura2", "sakura3", "sakura4", "sakura5", "sakura6"]
        
        scrollV = HelpScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollV.createHelpScrollV(nameArr: nameArray)
        view.addSubview(scrollV)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
