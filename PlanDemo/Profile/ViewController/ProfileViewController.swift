//
//  ProfileViewController.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var scrollV = ProfileScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "水野与志朗とは?"
        self.view.backgroundColor = UIColor.white
        
        initScrollV()

    }
    
    func initScrollV() {
        
        scrollV = ProfileScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollV.createScrollV()
        
        let bgImageV = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollV.frame.width, height: scrollV.frame.height))
        bgImageV.image = UIImage(named: "tokyoTower")
        scrollV.addSubview(bgImageV)

        view.addSubview(scrollV)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
