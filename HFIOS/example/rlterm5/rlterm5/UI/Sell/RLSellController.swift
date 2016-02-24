//
//  RLSellController.swift
//  rlterm3
//
//  Created by houfeng on 12/3/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import RLUtillties
class RLSellController: UIViewController {

    
    override func loadView(){
        var aView =  UIView(frame: CGRectMake(0, 0, RL_SCREEN_WIDTH, RL_SCREEN_HEIGHT))
        aView.backgroundColor = UIColor.whiteColor()
        self.view = aView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var statusCtr = RLStatusToolBarController(nibName: "RLStatusToolBarController", bundle: nil)
        self.addChildViewController(statusCtr)
        self.didMoveToParentViewController(statusCtr)
        self.view.addSubview(statusCtr.view)
        statusCtr.setStatusTitle(RL_LocalizedString("buymode") as String)
        
        
        var prodcutMenu = RLProductMenuView(frame:CGRectMake(-180, 100, 200, 500))
        prodcutMenu.minX =  -180
        prodcutMenu.maxX =  0
        self.view.addSubview(prodcutMenu)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
