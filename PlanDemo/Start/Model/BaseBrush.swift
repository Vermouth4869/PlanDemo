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
    
    var beginPoint: CGPoint! //开始点的位置
    var endPoint: CGPoint! //结束点的位置
    var lastPoint: CGPoint? //最后一个点的位置
    var strokeWidth: CGFloat! //画笔的宽度
    
    //表示是否是连续不断的绘图
    func supportedContinuousDrawing() -> Bool {
        return false
    }
    
    //基于Context的绘图方法，子类必须实现具体的绘图
    func drawInContext(context: CGContext) {
        
        assert(false, "must implements in subclass.")
        
    }

}
