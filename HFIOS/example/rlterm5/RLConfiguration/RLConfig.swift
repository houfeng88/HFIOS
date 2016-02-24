//
//  RLConfig.swift
//  rlterm3
//
//  Created by houfeng on 11/20/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import Foundation
import RLNetwork
let rl_makerConfigName:String = "config.xml"
let rl_termConfigName:String = "termconfig.xml"
public let RL_MAKER_PWD = "RL8899"
typealias XMLIndexer = RLNetwork.XMLIndexer

class RLConfigContext:NSObject{
    var _rxmlPath:String?
    var _xml:XMLIndexer!
    init(name:String?){
        super.init()
        if (name != nil) {
            let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
            var documentXmlPath:String = ""
            if (dirs) != nil {
                let dir = dirs![0];
                documentXmlPath = dir.stringByAppendingPathComponent(name!);
                
            }
            _rxmlPath = documentXmlPath;
            var configData = NSData(contentsOfFile: documentXmlPath)
            if  configData == nil {
                var bundleXmlPath =  NSBundle.mainBundle().pathForResource(name, ofType: nil)
                configData = NSData(contentsOfFile: bundleXmlPath!)
            }
            
            var xmlData =  getXMLData(configData)
           
            if xmlData == nil{
                println("xml data error")
            }else{
               _xml = SWXMLHash.parse(xmlData!)
            }
            
        }else{
            println("path can't be nil")
        }
        
        
    }
    
    
    func getXMLData(data:NSData?)->NSData?{
        
        return data
    }
    
    func writeToFile(){
        var data = _xml.toXMLString()?.dataUsingEncoding(NSUTF8StringEncoding)        
        if data != nil && _rxmlPath != nil {
            if  data!.writeToFile(_rxmlPath!, atomically: false) {
//                println("write ok")
            }else{
                 println("write error")
            }
        
        }
        
    }
    
    private func getXMLIndexerForKey(key:NSString)->XMLIndexer?{
        var keys = key.componentsSeparatedByString(".")
        
        var firstKey = keys[0] as! String
        var firstEle = _xml[firstKey]
        var currentEle:XMLIndexer?
        currentEle = firstEle
        var count  = 0
        for aKey in keys {
            if(count != 0){
                var subKey = aKey as! String
                currentEle = currentEle?[subKey]
            }
            count++
        }
        return currentEle
    }
    func getStringValueForKey(key:NSString!)->NSString?{
        var value:NSString?
        var currentEle = getXMLIndexerForKey(key)
        if currentEle != nil {
            return currentEle?.element?.text
        }else{
            return nil
        }
    }
    
    func setValueForKey(value:NSString,key:NSString){
        var currentEle = getXMLIndexerForKey(key)
        if currentEle != nil {
            currentEle!.element?.text = value as String
            writeToFile()
        }
        
    }
}

class RLConfigTermContext:RLConfigContext{
    
}

class RLConfigMakerContext:RLConfigContext{
    
   override func getXMLData(data:NSData?)->NSData?{
        
        return data
    }
    
    override func writeToFile(){
        super.writeToFile()
    }
}

public class RLConfig{
   public  class var shareConfig:RLConfig{
        struct RLConfigSingleton{
            static let instance:RLConfig = RLConfig()
        }
        return RLConfigSingleton.instance;
    }
    
    private var currentConfigContext:RLConfigContext?
    private var termConfigContext:RLConfigContext?
    private var makerConfigContext:RLConfigContext?
    
    
    init(){
        self.initTermConfig()
        self.initMakerConfig()
        
    }
    func initTermConfig() ->Void{
        self.termConfigContext = RLConfigTermContext(name: rl_termConfigName)
    }
    
    func initMakerConfig(){
        self.makerConfigContext = RLConfigMakerContext(name: rl_makerConfigName)
    }
    
   public func getMakerConfig()->RLConfig{
        
        self.currentConfigContext = self.makerConfigContext
        return self
    }
    
   public  func getTermConfig()->RLConfig{
        self.currentConfigContext = self.termConfigContext
        return self
    }
    
   public func getStringValueForKey(key:NSString)->NSString?{
        var myKey = "config.\(key)"
        return self.currentConfigContext?.getStringValueForKey(myKey)
    }
    
   public func setValueForKey(value:NSString,key:NSString){
         var myKey = "config.\(key)"
        self.currentConfigContext!.setValueForKey(value, key: myKey)
    }
    
    
   public func getBoolValueForKey(key:NSString)->Bool{
        var strValue =  getStringValueForKey(key)
        strValue = strValue?.uppercaseString
        if strValue != nil && (strValue!.isEqualToString("TRUE") || strValue!.isEqualToString("NO")) {
            return true
        }else{
            return false
        }
        
    }
    
  public  func setBoolValueForKey(aBool:Bool , key:NSString){
        var str = "false"
        if aBool{
         str = "true"
        }
        self.setValueForKey(str, key: key)
    }
    
}