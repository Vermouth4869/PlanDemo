//
//  HelpScrollView.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/21.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

class HelpScrollView: UIScrollView {

    func createHelpScrollV(nameArr: [String]) {
        
        self.backgroundColor = UIColor.white
        
        for i in 0..<7 {
            
            //背景图
            let imageV = UIImageView(image: UIImage(named: nameArr[i]))
            imageV.frame = CGRect(x: i * Int(UIScreen.main.bounds.size.width),
                                  y: 0,
                                  width: Int(UIScreen.main.bounds.size.width),
                                  height: Int(UIScreen.main.bounds.size.height))
            
            self.addSubview(imageV)
            
        }
        
        self.contentSize = CGSize(width: 7 * UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64)
        self.bounces = false
        self.isPagingEnabled = true
        
    }
    
    

}
