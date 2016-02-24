//
//  RLTimeLineController.swift
//  rlterm3
//
//  Created by houfeng on 12/3/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import SpriteKit
class RLTimeLineController: UIViewController {
    
//    var timeScroll:UIScrollView?
//    override func loadView() {
//        var aView = UIView(frame: CGRectMake(0, 0, RL_SCREEN_WIDTH, RL_SCREEN_HEIGHT-80))
//        self.view = aView
//        self.view.backgroundColor = UIColor.whiteColor()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        var lw = RLReservationSystem.shareSystem().config.timeLineWidth
//        var lh = RLReservationSystem.shareSystem().config.timeLineHeight
//        
//        
//        var totalHour = 24 + 5 + 5
//        var scrollW = CGFloat(totalHour) *  RLReservationSystem.shareSystem().config.hourPerPixel
//        
//        self.timeScroll = UIScrollView(frame: CGRectMake(100, 0, lw, lh))
//        self.timeScroll?.scrollEnabled = true
//        self.timeScroll?.showsHorizontalScrollIndicator = true
//        self.timeScroll?.showsVerticalScrollIndicator = true
//        self.timeScroll?.contentSize = CGSizeMake(scrollW, lh)
//        self.view.addSubview(self.timeScroll!)
//
//        var timeLineTable = RLTimeTable(frame: CGRectMake(0, 0, scrollW, lh))
//        self.timeScroll?.addSubview(timeLineTable)
//
//        
////        var timelineTable = RLTimeLineView(frame:CGRectMake(0, 0, scrollW, lh));
////        self.timeScroll?.addSubview(timelineTable)
////        timelineTable.showsFPS = true
////        timelineTable.showsDrawCount = true
////        var timelineScene = RLTimeLineViewController(size:timelineTable.bounds.size)
////        timelineScene.scaleMode  = SKSceneScaleMode.AspectFill
////        timelineTable.presentScene(timelineScene)
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
}
