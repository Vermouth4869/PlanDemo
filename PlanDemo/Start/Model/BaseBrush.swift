//
//  BaseBrush.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/21.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit
import CoreGraphics

protocol PaintBrush {
    
    func supportedContinuousDrawing() -> Bool;
    
    func drawInContext(context: CGContext)
    
}

class BaseBrush: NSObject, PaintBrush {
    
    var beginPoint: CGPoint! //开始的位置
    var endPoint: CGPoint! //结束的位置
    var lastPoint: CGPoint? //最后一个的位置
    var strokeWidth: CGFloat! //画笔的宽度
    
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    func drawInContext(context: CGContext) {
        
        assert(false, "must implements in subclass.")
        
    }

}
