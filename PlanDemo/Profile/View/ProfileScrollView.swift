//
//  ProfileScrollView.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/21.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

class ProfileScrollView: UIScrollView {

    func createScrollV() {
        
        self.backgroundColor = UIColor.white
        
        self.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 1.5)
        self.bounces = false
        self.isPagingEnabled = false
        
    }

}
