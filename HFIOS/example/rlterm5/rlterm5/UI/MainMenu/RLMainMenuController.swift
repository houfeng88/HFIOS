//
//  RLMainMenuController.swift
//  rlterm3
//
//  Created by houfeng on 11/24/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import RLUtillties
import RLCore
import RLConfiguration
let F_BUTTON_LINE_NUM:Int = 5




class RLMainMenuController: UIViewController {

    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var logoView: UIImageView!
    
    @IBOutlet weak var factoryLabel: UILabel!
    
    @IBOutlet weak var shopLabel: UILabel!
    
    @IBOutlet weak var shopNoLabel: UILabel!
    
    private var toolBar:UIView!
    
    private var buttonImageNames:NSMutableArray!
    private var maybeChangeButtonConfig:Bool!;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        RLLOGGER().info("RLMainMenuController viewDidLoad")
        maybeChangeButtonConfig = false
        buttonImageNames = NSMutableArray()
        
        
        
        RLTESTLOG("viewload info")
        
        self.toolBar = UIView(frame: CGRectMake(0, 0, RL_SCREEN_WIDTH, 350))

        self.bgView.addSubview(toolBar)
        
        var copyrightLabel:UILabel = RLUtilities.getCopyRightLabelWithFrame(CGRectMake(0, 725, RL_SCREEN_WIDTH, 40))
        self.bgView.addSubview(copyrightLabel)
        
        self.loadFunctionButtonsWithUpdateButton(true)
        
        //init controller manager
        RLControllerManager.shareManager.setMainNavigation(self.navigationController!)
        
        var isInit = RLTerminalInfo.getIsInited()
        
        if(!isInit){
              RLTerminalInfo.setIsInited(false)
              RLControllerManager.shareManager.gotoLoginControl()
        }else{
            RLTerminalInfo.shareTerminalInfo().update({ updated in
                if updated {
                    RLLOGGER().info("terminalinfo updated success")
                     self.updeteUI()
                     RLTerminalInfo.shareTerminalInfo().downloadPrintLogo(force: false, block: nil)
                }else{
                     RLLOGGER().info("terminalinfo updated error")
                }
               
            })
            
        }
        
    }
    
    
    func updeteUI(){
        
        if(RLTerminalInfo.shareTerminalInfo().shopInfo != nil){
            if let shopName = RLTerminalInfo.shareTerminalInfo().shopInfo?.name {
                 self.shopLabel.text =  (RLTerminalInfo.shareTerminalInfo().shopInfo?.name as! String)
            }
        }
        if RLTerminalInfo.shareTerminalInfo().shopInfo?.ID != nil {
             self.shopNoLabel.text = ( RLTerminalInfo.shareTerminalInfo().shopInfo?.ID as! String)
        }
        if let  scName = RLTerminalInfo.shareTerminalInfo().shopInfo?.scName {
             self.factoryLabel.text  =  ((RLTerminalInfo.shareTerminalInfo().shopInfo?.scName) as! String)
        }
       
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadFunctionButtonsWithUpdateButton(maybeChangeButtonConfig)
        self.updeteUI()
    }
    
    
    func loadFunctionButtonsWithUpdateButton(update:Bool)->Void{
        if(update){
             buttonImageNames.removeAllObjects()
            
             buttonImageNames.addObject("firstmenu_maishang_btn")
             buttonImageNames.addObject("firstmenu_maishangguanli_btn")
             buttonImageNames.addObject("firstmenu_gukeguanli_btn")
            
            var useReservation = RLConfig.shareConfig.getMakerConfig().getBoolValueForKey("system.use_reservation")
            if(useReservation){
                 buttonImageNames.addObject("rese_btn")
            }
            
            
            var bUseCaseHistory = RLConfig.shareConfig.getMakerConfig().getBoolValueForKey("system.use_customer_survey")
            if(useReservation){
                buttonImageNames.addObject("btnGotoCH")
            }
            
            var use_customer_survey = RLConfig.shareConfig.getMakerConfig().getBoolValueForKey("system.use_casehistory")
            if(useReservation){
                buttonImageNames.addObject("firstmenu_survey")
            }

            buttonImageNames.addObject("firstmenu_tool_btn")
            
            var buttonCount = buttonImageNames.count
            
            var bgImg:UIImage?
            if buttonCount > F_BUTTON_LINE_NUM {
                bgImg = UIImage(named: "firstmenu_bg")
                
                self.toolBar.setY(self.view.frame.size.height-toolBar.frame.size.height-45)
                self.toolBar.setHeight(350)
                
                self.logoView.setXY(80, y: 122)
                
                
            }else{
                
                 bgImg = UIImage(named: "firstmenu_bg0")
                
                self.toolBar.setY(self.view.frame.size.height-toolBar.frame.size.height-40)
                self.toolBar.setHeight(200)
                
                self.logoView.setXY(80, y: 180)
            }
            
            bgView.image = bgImg
            
            self.toolBar.removeAllSubViews()
           
            var i:Int = 0;
            var x:Int=0,y:Int=0
            
            var startX:CGFloat = 180.0
            var astepX:CGFloat = 220.0
            var startY:CGFloat = 80.0
            var stepY:CGFloat  = 10.0
            
            var SX = F_BUTTON_LINE_NUM
            
            if buttonCount == F_BUTTON_LINE_NUM{
                startX = 130.0;
                astepX = 190.0;
                startY = 90.0;
                stepY =  10.0;
            }else if buttonCount > F_BUTTON_LINE_NUM{
                startX = 130.0;
                astepX = 190.0;
                startY = 100;
                stepY =  10.0;
            }
            
            for buttonName in buttonImageNames {
                x = i % SX;
                y = i / SX;
                
                var image = UIImage(named: buttonName as! String)
                var imagel = UIImage(named: "\(buttonName as! String)l")
                if image != nil{
                    var button:UIButton = UIButton(frame: CGRectMake(0,0, image!.size.width, image!.size.height))
                    var  X = CGFloat(x)
                    
                    var  buttonX = startX + astepX * CGFloat(x)
                    var  buttonY = startY + CGFloat(y) * (stepY + image!.size.height)
                    
                    button.center = CGPointMake(buttonX,buttonY)
                    
                    button.setImage(image, forState: UIControlState.Normal)
                    button.setImage(imagel, forState: UIControlState.Highlighted)
                    button.addTarget(self, action: Selector(buttonName as! String), forControlEvents: UIControlEvents.TouchUpInside)
                    toolBar.addSubview(button)
                }
              
                
                i++
            }
            
            maybeChangeButtonConfig  = false
            
        }
        
        
    }
    
    func firstmenu_maishang_btn(){
        RLControllerManager.shareManager.gotoSellControl()
    }
    
    func firstmenu_maishangguanli_btn(){
        
    }
    func firstmenu_gukeguanli_btn(){
        
    }
    
    func rese_btn(){
        RLControllerManager.shareManager.gotoReservation()
    }
    
    func btnGotoCH(){
        
    }
    
    func firstmenu_tool_btn(){
        RLControllerManager.shareManager.gotoSetControl()
    }
    
    func firstmenu_survey(){
        
    }
}
