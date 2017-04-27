//
//  Board.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/21.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

enum DrawingState {
    case Began, Moved, Ended
}

class Board: UIImageView {
    
    fileprivate class DBUndoManager {
        class DBImageFault: UIImage {}
        
        fileprivate static let INVALID_INDEX = -1
        fileprivate var images = [UIImage]()
        fileprivate var index = INVALID_INDEX
        
        var canUndo: Bool {
            get {
                return index != DBUndoManager.INVALID_INDEX
            }
        }
        
        var canRedo: Bool {
            get {
                return index + 1 < images.count
            }
        }
        
        func addImage(_ image: UIImage) {
            // 当往这个 Manager 中增加图片的时候，先把指针后面的图片全部清掉，
            // 这与我们之前在 drawingImage 方法中对 redoImages 的处理是一样的
            if index < images.count - 1 {
                images[index + 1 ... images.count - 1] = []
            }
            
            images.append(image)
            
            // 更新 index 的指向
            index = images.count - 1
            
            setNeedsCache()
        }
        
        func imageForUndo() -> UIImage? {
            if self.canUndo {
                index -= 1
                if self.canUndo == false {
                    return nil
                } else {
                    setNeedsCache()
                    return images[index]
                }
            } else {
                return nil
            }
        }
        
        func imageForRedo() -> UIImage? {
            var image: UIImage? = nil
            if self.canRedo {
                image = images[index+1]
            }
            setNeedsCache()
            return image
        }
        
        
        fileprivate static let cahcesLength = 3 // 在内存中保存图片的张数，以 index 为中心点计算：cahcesLength * 2 + 1
        fileprivate func setNeedsCache() {
            if images.count >= DBUndoManager.cahcesLength {
                let location = max(0, index - DBUndoManager.cahcesLength)
                let length = min(images.count - 1, index + DBUndoManager.cahcesLength)
                for i in location ... length {
                    autoreleasepool {
                        let image = images[i]
                        
                        if i > index - DBUndoManager.cahcesLength && i < index + DBUndoManager.cahcesLength {
                            setRealImage(image, forIndex: i) // 如果在缓存区域中，则从文件加载
                        } else {
                            setFaultImage(image, forIndex: i) // 如果不在缓存区域中，则置成 Fault 对象
                        }
                    }
                }
            }
        }
        
        fileprivate static var basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        fileprivate func setFaultImage(_ image: UIImage, forIndex: Int) {
            if !image.isKind(of: DBImageFault.self) {
                let imagePath = (DBUndoManager.basePath as NSString).appendingPathComponent("\(forIndex)")
                try? UIImagePNGRepresentation(image)!.write(to: URL(fileURLWithPath: imagePath), options: [])
                images[forIndex] = DBImageFault()
            }
        }
        
        fileprivate func setRealImage(_ image: UIImage, forIndex: Int) {
            if image.isKind(of: DBImageFault.self) {
                let imagePath = (DBUndoManager.basePath as NSString).appendingPathComponent("\(forIndex)")
                images[forIndex] = UIImage(data: try! Data(contentsOf: URL(fileURLWithPath: imagePath)))!
            }
        }
    }
    
    private var drawingState: DrawingState!
    var storkeWidth: CGFloat! = 5
    var storkeColor: UIColor! = UIColor.black
    var brush: BaseBrush? //画笔
    private var realImage: UIImage? //保存当前的图形
    var drawingStateChangedBlock: ((_ state: DrawingState) -> ())?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let brush = self.brush {

            brush.lastPoint = nil
            brush.beginPoint = touches.first?.location(in: self)
            brush.endPoint = brush.beginPoint
            
            self.drawingState = .Began
            self.drawingImage()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let brush = self.brush {
            
            brush.endPoint = touches.first?.location(in: self)
            
            self.drawingState = .Moved
            self.drawingImage()
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let brush = self.brush {
            
            brush.endPoint = nil
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let brush = self.brush {
            
            brush.endPoint = touches.first?.location(in: self)
            
            self.drawingState = .Ended
            self.drawingImage()
            
        }
        
    }
    
    private func drawingImage() {
        
        if let brush = self.brush {
            
            if let drawingStateChangedBlock = self.drawingStateChangedBlock {
                drawingStateChangedBlock(self.drawingState)
            }
            
            //1.
            UIGraphicsBeginImageContext(self.bounds.size)
            
            //2.
            let context = UIGraphicsGetCurrentContext()
            UIColor.clear.setFill()
            UIRectFill(self.bounds) 
            
            context!.setLineCap(CGLineCap.round)
            context!.setLineWidth(self.storkeWidth)
            context!.setStrokeColor(self.storkeColor.cgColor)
            
            //3.
            if let realImage = self.realImage {
                
                realImage.draw(in: self.bounds)
                
            }
            
            //4.
            brush.strokeWidth = self.storkeWidth
            brush.drawInContext(context: context!)
            context!.strokePath()
            
            //5.
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .Ended || brush.supportedContinuousDrawing() {
                
                self.realImage = previewImage
                
            }
            UIGraphicsEndImageContext()
            
            //6.
            self.image = previewImage
            
            brush.lastPoint = brush.endPoint
            
        }
        
    }

}
