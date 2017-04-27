//
//  PencilBrush.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/23.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

class PencilBrush: BaseBrush {
    
    override func drawInContext(context: CGContext) {
        
        if let lastPoint = self.lastPoint {
            
            context.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
            
        } else {
            
            context.move(to: CGPoint(x: beginPoint.x, y: beginPoint.y))
            context.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
            
        }
        
    }
    
    override func supportedContinuousDrawing() -> Bool {
        
        return true
        
    }

}
