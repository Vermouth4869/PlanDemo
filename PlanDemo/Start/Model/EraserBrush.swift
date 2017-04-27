//
//  EraserBrush.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/23.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

class EraserBrush: PencilBrush {
    
    override func drawInContext(context: CGContext) {
        context.setBlendMode(CGBlendMode.clear)
        
        super.drawInContext(context: context)
    }
    
}
