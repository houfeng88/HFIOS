//
//  RLLoginViewController.swift
//  rlterm3
//
//  Created by houfeng on 11/24/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import RLCore
import RLUtillties
class RLLoginViewController: UIViewController {

    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var loginTextField: UITextField!
    
    
    @IBAction func onlineLogin(sender: AnyObject) {
        RLControllerManager.shareManager.goBackToMainMenu()
    }
    @IBAction func demoModelLogin(sender: AnyObject) {
        
        
        RLTerminalInfo.setIsOnlineMode(false)
        RLTerminalInfo.shareTerminalInfo().update({ updated in
            if updated {
                RLControllerManager.shareManager.goBackToMainMenu()
                
                RLTerminalInfo.shareTerminalInfo().downloadPrintLogo(force: false, block: nil)
            }
            
        })

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var copyrightLabel:UILabel = RLUtilities.getCopyRightLabelWithFrame(CGRectMake(0, 695, RL_SCREEN_WIDTH, 40))
        self.bgView.addSubview(copyrightLabel)
        
    }
}
