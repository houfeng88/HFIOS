//
//  RLSetView.swift
//  rlterm3
//
//  Created by houfeng on 11/25/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit

class RLSetView: UIView {

    internal var type:RLSetItemType?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    internal func show(){
        self.hidden = false
    }
    
    internal func hide(){
        self.hidden = true
    }

}
