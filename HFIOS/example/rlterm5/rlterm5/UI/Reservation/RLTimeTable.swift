//
//  RLTimeTable.swift
//  rlterm3
//
//  Created by houfeng on 12/4/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit

class RLTimeTable: UIView {

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.grayColor()
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override func drawRect(rect: CGRect) {
//        
//        var allRect = self.bounds
//        var ctx = UIGraphicsGetCurrentContext()
//        
//        var hourLineNum = RLReservationSystem.shareSystem().config.totalHourLine
//        
//        var stepHourX =  allRect.width / CGFloat(hourLineNum)
//        
//        
//        CGContextSaveGState(ctx)
//        CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1)
//        CGContextSetRGBFillColor(ctx, 0, 0, 0, 1)
//        CGContextSetLineWidth(ctx, 2.0)
//        var hourpath:CGMutablePathRef = CGPathCreateMutable()
//        for var i = 0 ; i < hourLineNum ; i++ {
//            var x = CGFloat(i) * stepHourX
////            CGPathMoveToPoint(hourpath, nil,x, 0)
////            CGPathAddLineToPoint(hourpath, nil, x, allRect.height)
//            
//            CGContextMoveToPoint(ctx, x, 0)
//            CGContextAddLineToPoint(ctx, x, allRect.height)
//            
//        }
//        CGContextClosePath(ctx)
//        CGContextFillPath(ctx)
//        CGContextRestoreGState(ctx)
//        
//        CGContextSaveGState(ctx)
//        var minLineNum =  hourLineNum * Int(RLReservationSystem.shareSystem().config.mintueLineInAnHour)
//        var stepMinX =  allRect.width / CGFloat(minLineNum)
//        var minpath = CGPathCreateMutable()
//        CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0.5)
//         CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5)
//        CGContextSetLineWidth(ctx, 1.0)
//        for var i = 0 ; i < minLineNum ; i++ {
//            var x = CGFloat(i) * stepMinX
////            CGPathMoveToPoint(minpath, nil,x, 0)
////            CGPathAddLineToPoint(minpath, nil, x, allRect.height)
//            
//            CGContextMoveToPoint(ctx, x, 0)
//            CGContextAddLineToPoint(ctx, x, allRect.height)
//
//        }
//        CGContextClosePath(ctx)
//        CGContextFillPath(ctx)
//        CGContextRestoreGState(ctx)
//       
//        
//        
//        
//    }

}
