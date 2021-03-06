//
//  ViewController.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController {
    
    let borderWidth: CGFloat = 5.0 //按钮边框宽
    let cornerRadius: CGFloat = 10.0 //按钮圆角值
    
    let btnX: Int = Int(UIScreen.main.bounds.width) / 4 //按钮X坐标
    let btnY: Int = Int(UIScreen.main.bounds.width) / 10 * 3 //按钮Y坐标
    let btnWidth: Int = Int(UIScreen.main.bounds.width) / 2 //按钮宽度
    let btnHeight: Int = 50 //按钮高度
    let btnSpace: Int = 30 //按钮间隔
    
    let titleArr: [String] = ["START はじめよう!", "HELP アプリの使い方", "相談MAIL", "bmwinホームページ", "水野与志朗PROFILE"] //按钮title文字
    let colorArr: [UIColor] = [UIColor(red: 58 / 255, green: 131 / 255, blue: 213 / 255, alpha: 1.0),
                               UIColor(red: 72 / 255, green: 50 / 255, blue: 141 / 255, alpha: 1.0),
                               UIColor(red: 0 / 255, green: 199 / 255, blue: 50 / 255, alpha: 1.0),
                               UIColor(red: 255 / 255, green: 118 / 255, blue: 62 / 255, alpha: 1.0),
                               UIColor(red: 216 / 255, green: 0 / 255, blue: 113 / 255, alpha: 1.0)] //按钮颜色
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        initBtn()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    //初始化5个按钮
    func initBtn() {
        
        for i in 0..<5 {
            
            let btn = UIButton(frame: CGRect(x: btnX, y: btnY + (btnHeight + btnSpace) * i, width: btnWidth, height: btnHeight))
            btn.setTitle(titleArr[i], for: .normal)
            btn.setTitleColor(colorArr[i], for: .normal)
            btn.layer.borderWidth = borderWidth
            btn.layer.borderColor = colorArr[i].cgColor
            btn.layer.cornerRadius = cornerRadius
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
            self.view.addSubview(btn)
            
        }
    
    }
    
    //按钮点击事件
    func btnAction(sender: UIButton) {

        switch sender.tag - 100 {
        case 0:
            self.navigationController?.pushViewController(CategoryListViewController(), animated: true)
        default:
            break
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
