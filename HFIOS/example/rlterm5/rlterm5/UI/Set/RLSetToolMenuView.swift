//
//  RLSetToolMenuView.swift
//  rlterm3
//
//  Created by houfeng on 11/25/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit

public enum RLSetItemType:Int{
    case UserSet = 0
    case UpdateInfo = 1
    case Check = 2
    case MakerSet = 3
    case Exit = 4
    
    func itemName()->String{
        switch (self){
        case .UserSet :
            return "UserSet"
        case .UpdateInfo :
            return "UpdateInfo"
        case .Check :
            return "Check"
        case .MakerSet :
            return "MakerSet"
        case .Exit :
            return "Exit"
        default:
            return "UserSet"
            
        }
    }
}


class RLSetFunctionButton:UIButton{
    internal var item:RLSetItemType?
    internal var NormalImageName:NSString?
    internal var SelectImageName:NSString?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func setBeActivated(aBool:Bool){
        var image:UIImage?
        if aBool {
             image = UIImage(named:self.SelectImageName! as String)
            
        }else{
             image = UIImage(named:self.NormalImageName! as String)
        }
        if image != nil {
            self.setImage(image, forState: UIControlState.Normal)
             self.setImage(image, forState: UIControlState.Highlighted)
            self.setWidth(image!.size.width)
        }
        
    }

}

class RLSetToolMenuView: UIView {

    //internal 可以访问自己模块或者应用中源文件中得任何实体.但是别人不能访问改模块源文件中得实体
    internal var selectCallBack:((RLSetItemType) ->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var startY:CGFloat = 100.0
        
        for var i=0 ; i < 5 ; i++ {
           var item = RLSetItemType(rawValue: i)
            if item != nil {
                 println(item?.itemName())
                
                var imageName = "tool_\(item!.itemName())"
                var imageName_H = "\(imageName)_H"
                
                var image = UIImage(named: imageName)
                var image_H = UIImage(named: imageName_H)
                
                if image != nil {
                    var button:RLSetFunctionButton = RLSetFunctionButton(frame: CGRectMake(0, startY + (CGFloat(i) * (image!.size.height + 2)),  image!.size.width,  image!.size.height))
                   
                    button.NormalImageName = imageName;
                    button.SelectImageName = imageName_H;
                    button.setImage(image, forState: UIControlState.Normal)
                    button.setImage(image, forState: UIControlState.Highlighted)
                    button.item = item
                    if i == 0 {
                      button.setBeActivated(true)
                    }
                    button.addTarget(self, action: Selector("selectFunction:"), forControlEvents: UIControlEvents.TouchUpInside)
                    self.addSubview(button)
                    
                }
               
               
                
                
            }
            
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func selectFunction(btn:RLSetFunctionButton){
        self.activatedButton(btn)
        if self.selectCallBack != nil {
            self.selectCallBack!(btn.item!)
        }
    }
    
    func activatedButton(btn:RLSetFunctionButton){
        
        for view in self.subviews {
            if view  is RLSetFunctionButton {
                var subBtn = view as! RLSetFunctionButton
                if subBtn.item?.rawValue == btn.item?.rawValue {
                    subBtn.setBeActivated(true)
                }else {
                    subBtn.setBeActivated(false)
                }
            }
        }
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
