//
//  RLSetViewController.swift
//  rlterm3
//
//  Created by houfeng on 11/24/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import RLUtillties
import RLConfiguration
class RLSetViewController: UIViewController {


    @IBOutlet weak var toolBgView: UIImageView!
    var views:NSMutableArray!
    var curType:RLSetItemType!
    
    var makerPwdText:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        views = NSMutableArray()
        
        
        var statusCtr = RLStatusToolBarController(nibName: "RLStatusToolBarController", bundle: nil)
        self.addChildViewController(statusCtr)
        self.didMoveToParentViewController(statusCtr)
        self.view.addSubview(statusCtr.view)
         statusCtr.setStatusTitle(RL_LocalizedString("toolmenu") as String)
        
        
        var frame = CGRectMake( self.toolBgView.frame.size.width+10, statusCtr.view.frame.size.height, self.view.frame.size.width - self.toolBgView.frame.size.width-20, self.view.frame.size.height - statusCtr.view.frame.size.height)
        
        
        var userSetView = RLUserSetView(frame: frame)
        userSetView.type = RLSetItemType.UserSet
        self.view.addSubview(userSetView)
        views.addObject(userSetView)
        
        
        var updateSetCtl = RLSetUpdateController(nibName:"RLSetUpdateController",bundle:nil)
        self.addChildViewController(updateSetCtl)
        self.didMoveToParentViewController(updateSetCtl)
        var updateSetView  = updateSetCtl.view as! RLSetView
        updateSetView.type = RLSetItemType.UpdateInfo
        updateSetView.setXY(170,y: statusCtr.view.frame.size.height)
        updateSetView.hide()
        self.view.addSubview(updateSetView)
        views.addObject(updateSetView)
        
        
        var makerSetView = RLMakerSetView(frame: frame)
        makerSetView.type = RLSetItemType.MakerSet
        self.view.addSubview(makerSetView)
        views.addObject(makerSetView)


        self.showViewByType(.UserSet)
        curType = .UserSet
        
        var toolMenu = RLSetToolMenuView(frame: CGRectMake(0, 0, self.toolBgView.frame.size.width+50, self.toolBgView.frame.size.height))
        self.toolBgView.addSubview(toolMenu)
        
        toolMenu.selectCallBack = { (item:RLSetItemType) in
            self.curType = item
            if item == .MakerSet {
                var alertMaker = UIAlertController(title: RL_LocalizedString("InputPasswordtitle") as String, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                alertMaker.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    self.makerPwdText =  textField
                    
                    textField.placeholder = ""
                    textField.secureTextEntry = true
                })
            
                
                
                alertMaker.addAction(UIAlertAction(title: RL_LocalizedString("Cancel") as String, style: .Default, handler: { action in
                    
                }))
                
                alertMaker.addAction(UIAlertAction(title: RL_LocalizedString("Ok") as String, style: .Default, handler: { action in
                    
                    var pwd = self.makerPwdText?.text as NSString?
                    if pwd != nil {
                        if  pwd!.isEqualToString(RL_MAKER_PWD) {
                            self.showViewByType(item)
                        }
                    }
                    
                }))
                
                self.presentViewController(alertMaker, animated: true, completion: nil)
                
            }else if (item == .Exit){
                
                var alertCtr:UIAlertController = UIAlertController(title: RL_LocalizedString("Message") as String, message: RL_LocalizedString("closerlter as Stringmmessage") as String, preferredStyle: UIAlertControllerStyle.Alert)
                alertCtr.addAction(UIAlertAction(title: RL_LocalizedString("Ok") as String, style: .Default, handler: { action in
                    exit(0)
                }))
                
                alertCtr.addAction(UIAlertAction(title: RL_LocalizedString("Cancel") as String, style: .Default, handler: { action in
                    
                }))
                self.presentViewController(alertCtr, animated: true, completion: nil)
            }else{
                self.showViewByType(item)
            }
            
        }
         // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showViewByType(type:RLSetItemType){
        
        for aView in views {
            let itemView = aView as! RLSetView
            if itemView.type != nil {
                if itemView.type == type {
                    itemView.show()
                }else {
                    itemView.hide()
                }
            }
            
        }
        
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
