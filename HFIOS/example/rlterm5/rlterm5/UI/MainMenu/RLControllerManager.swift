//
//  RLControllerManager.swift
//  rlterm3
//
//  Created by houfeng on 11/24/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import RLUtillties
class RLControllerManager: NSObject {
    class var shareManager:RLControllerManager{
        struct RLConfigSingleton{
            static let instance:RLControllerManager = RLControllerManager()
        }
        return RLConfigSingleton.instance;
    }

    private var mainNav:UINavigationController?
    
    func setMainNavigation(nav:UINavigationController){
        self.mainNav = nav
    }
    
    func getMainNav() -> UINavigationController? {
        return self.mainNav
    }
    
    func goBackToMainMenu(){
        if self.mainNav != nil{
            self.mainNav!.popToRootViewControllerAnimated(true)
        }
    }
    
    func goBack(){
        if self.mainNav != nil {
            self.mainNav?.popViewControllerAnimated(true)
        }
    }
    
    func gotoLoginControl() -> Void{
        
        if self.mainNav != nil {
            
            var stroyboard = RLUtilities.getRLMainStroyboard()
            
            var loginContorl =  stroyboard.instantiateViewControllerWithIdentifier("RLoginViewController") as! RLLoginViewController
            self.mainNav!.pushViewController(loginContorl, animated: true)
            
            
            
        }
        
    }
    
    func gotoSellControl(){
        var sellControl = RLSellController()
        self.mainNav!.pushViewController(sellControl, animated: true)
    }
    func gotoSellManagerControl(){
        
    }
    
    func gotoCustomerManagerControl(){
        
    }
    
    func gotoReservation(){
        var reseControl = RLReservationController()
        self.mainNav!.pushViewController(reseControl, animated: true)
    }
    
    
    
    func gotoSetControl(){
        var stroyboard = RLUtilities.getRLMainStroyboard()
        var loginContorl =  stroyboard.instantiateViewControllerWithIdentifier("RLSetViewController") as! RLSetViewController
        self.mainNav!.pushViewController(loginContorl, animated: true)
    }
    
}
