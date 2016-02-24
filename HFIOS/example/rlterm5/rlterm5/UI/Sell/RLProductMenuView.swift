//
//  RLProductMenuView.swift
//  rlterm3
//
//  Created by houfeng on 12/4/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import RLCore

class RLProductCell:UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}

class RLProductMenuView: UIView,UITableViewDataSource,UITableViewDelegate {

    private var productTable:UITableView?
    private var secondTable:UITableView?
    internal var minX:CGFloat = 0.0
    internal var maxX:CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        
        
        self.productTable = UITableView(frame: self.bounds)
        self.productTable?.delegate = self
        self.productTable?.dataSource = self
        self.productTable?.registerClass(RLProductCell.classForCoder(), forCellReuseIdentifier: "Cell")
        self.addSubview(self.productTable!)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight:"))
        self.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft:"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipeLeft)

        
        var tap = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        self.addGestureRecognizer(tap)
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return ""
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var count = RLTerminalInfo.shareTerminalInfo().productTree?.children != nil ?   RLTerminalInfo.shareTerminalInfo().productTree!.children.count : 0
        
        return count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RLProductCell
        return cell
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func swipeRight(ges:UISwipeGestureRecognizer){
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.setX(self.maxX)
            }, completion: {f in
                
        })
    }
    
    
    func swipeLeft(ges:UISwipeGestureRecognizer){
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.setX(self.minX)
            }, completion: {f in
                
        })
    }
    
    func tap(ges:UITapGestureRecognizer){
        
    }

}
