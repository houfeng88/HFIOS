//
//  RLTerminalInfo.swift
//  rlterm3
//
//  Created by houfeng on 11/24/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import RLNetwork
import RLConfiguration
import RLUtillties

public typealias RLTermainalUpdateBlock  = ((updated:Bool)->Void)?
public typealias RLTermainalDownloadFileBlock = ((file:NSString?)->Void)?
public class RLTerminalInfo: NSObject {
   
    
    
   public class  func shareTerminalInfo() -> RLTerminalInfo{
        struct RLSingeton{
           static let termainlInfo = RLTerminalInfo()
        }
        return RLSingeton.termainlInfo
    }


   public class func getIsOnlineMode()->Bool{
        return RLConfig.shareConfig.getMakerConfig().getBoolValueForKey("system.use_rlcomm")
    }
    
  public  class func setIsOnlineMode(aBool:Bool){
        
        RLConfig.shareConfig.getMakerConfig().setBoolValueForKey(aBool, key: "system.use_rlcomm")
    }
    
   public class func getIsInited() -> Bool{
        return RLConfig.shareConfig.getTermConfig().getBoolValueForKey("initkey")

    }
    
   public class func setIsInited(aBool:Bool){
         RLConfig.shareConfig.getTermConfig().setBoolValueForKey(aBool, key: "initkey")
    }
    
    
    
    private var xml:AEXMLDocument?
    private var hasUpdated:Bool = false
    
    public var shopInfo:RLShopInfo?
    public var shopTime:NSString?
    public var staffList:RLStaffList?
    public var productTree:RLProductTree?
    
    
    
    override init() {
        super.init()
    }
    
    
    
   public func forceUpdate(block:RLTermainalUpdateBlock){
        self.hasUpdated = false
        self.update({updated in
            
            if block != nil {
                block!(updated: updated)
            }
            
        })
    }
    
    
   public func update(block:RLTermainalUpdateBlock) {
        
        if !self.hasUpdated {
           var isOnline = RLTerminalInfo.getIsOnlineMode()
            if !isOnline {
                
                var fileName =  "/TerminalInfoDummyMH.xml"
                var business_type = RLConfig.shareConfig.getMakerConfig().getStringValueForKey("system.business_type")
                if business_type != nil {
                    if business_type!.isEqualToString("bone_setter") {
                        fileName =  "/TerminalInfoDummyKF.xml"
                    }else if business_type!.isEqualToString("beauty"){
                         fileName =  "/TerminalInfoDummyMH.xml"
                    }
                }
        
                var bundlePath = RLUtilities.getBundleDirecory()
                var xmlData = NSData(contentsOfFile: "\(bundlePath)\(fileName)")
                if xmlData != nil {
                    self.initData(xmlData!)
                }
                
            }else{
                
                
        
                
                var url = RLUtilities.getURLWithKey("get_terminal_info")
                var  infoDic:Dictionary<String,AnyObject> = Dictionary<String,String>()
                var clientid  = RLConfig.shareConfig.getTermConfig().getStringValueForKey("rlty4_id")
                var accesskey  = RLConfig.shareConfig.getTermConfig().getStringValueForKey("access_key")
                var clienttime  = RLUtilities.getLocalTimeString()
                var firmverion = RLUtilities.versions()
                var terminalType = "1"
                var serialno = "1"
                infoDic["clientid"] = clientid
                infoDic["accesskey"] = accesskey
                
                infoDic["clienttime"] = clienttime
                infoDic["terminalType"] = terminalType
                infoDic["serialno"] = serialno;
               
                var request =  RLNetwork.RLHttpTask()
                request.POST(url!, parameters: infoDic, success: { response in
                    if  response.responseObject != nil{
                        let  data =  response.responseObject as? NSData
                        if data != nil {
                            self.initData(data!)
                            if block != nil {
                                block!(updated: true)
                            }
                        }
                    }
                 }, failure: { (error,_) in
                
                        if block != nil {
                            block!(updated: false)
                        }
                        println("failure")

                 } )
                
            }
            
        }else{
            
        }
        
        
    }
    
    
    
    func initData(data:NSData){
        self.setData(data)
        
// 这种方式解析 灵活一点 但是 在这个类里面数据量比较大，解析比较慢，还是用下面直接的方式
//        self.shopInfo = RLShopInfo(parseContext: self.getParseContentForKey("shopInfo"))
//        self.shopTime =  self.getContentStringForKey("time")
//        self.staffList = RLStaffList(parseContext: self.getParseContentForKey("staffs"))
//        self.productTree = RLProductTree(parseContext: self.getParseContentForKey("categories"))

        
    }
    
    func setData(data:NSData){
        if rl_prase_type == .XML {
            if xml == nil {
                var error:NSError?
                xml  =  AEXMLDocument(xmlData:data,error: &error)
                var shopInfocontent = RLParseXMLContent(xmlEle: xml?.rootElement["shopInfo"])
                self.shopInfo = RLShopInfo(parseContext: shopInfocontent)
                self.shopTime =  self.getContentStringForKey("time")
                self.staffList = RLStaffList(parseContext:  RLParseXMLContent(xmlEle: xml?.rootElement["staffs"]))
//                
//                var queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//                dispatch_async(queue, {
//                
//                
//                
//                })

                var categoriesContext:RLParseContent =  RLParseXMLContent(xmlEle: xml?.rootElement["categories"])
                self.productTree = RLProductTree(parseContext: categoriesContext)
            }
            
        }else{
            
            
        }
    }
    
    func getParseContentForKey(key:NSString) -> RLParseContent?{
         return   RLParseContentFactory.createContextByString(self.getContentStringForKey(key))
    }
    
    func getContentStringForKey(key:NSString) -> NSString?
    {
        if rl_prase_type == .XML {
            return xml?.rootElement[key as! String]?.xmlString
        }else{
            return nil
        }
    
    }
    
    public func downloadPrintLogo(force f:Bool,block:RLTermainalDownloadFileBlock){
        
    }
    
    
}
