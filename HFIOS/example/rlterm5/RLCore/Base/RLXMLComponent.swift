//
//  RLXMLNode.swift
//  rlterm3
//
//  Created by houfeng on 11/28/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import RLNetwork
typealias AEXMLDocument = RLNetwork.AEXMLDocument

class RLXMLComponent: RLParseComponet {
    private var xmlDoc:AEXMLDocument?
    override init(content c:NSString){
        super.init(content:c)
        var error:NSError?
        xmlDoc = AEXMLDocument(xmlString:c,error:&error)
        if error != nil {
            xmlDoc = nil
        }
        
    }
    
    override init(parseContent:RLParseContent?){
        super.init(parseContent:parseContent)
        
        
    }
    
    override func getParsedString()-> NSString?{
        if self.getParseContent() != nil {
            return self.getParseContent()?.getParsedString()
        }
        return xmlDoc?.xmlString
    }
    
    

    
    override  func getStringValueForKey(key:NSString)->NSString?{
        if self.getParseContent() != nil {
            return self.getParseContent()?.getStringValueForKey(key)
        }
       return  self.xmlDoc?.rootElement[key as! String]?.value
    }
    
    
    override func getArrayValueForyKey(key:NSString)-> NSMutableArray?{
        
        if self.getParseContent() != nil {
            return self.getParseContent()?.getArrayValueForyKey(key)
        }
        var arr:NSMutableArray?
        var children = self.xmlDoc?.rootElement[key as String]
        arr = self.getArr(children)
        return arr
        
    }
    
    
    override func getParseStringByKey(key:NSString)->NSString?{
        
        if self.getParseContent() != nil {
            return self.getParseContent()?.getParseStringByKey(key)
        }
        return self.xmlDoc?.rootElement[key as! String]?.xmlString
    }
    
    override  func getArrayValueFromSuperKey(key:NSString,superKey:NSString) -> NSMutableArray?{
        
        if self.getParseContent() != nil {
            return self.getParseContent()?.getArrayValueFromSuperKey(key, superKey: superKey)
        }
        
        var superContent = self.getStringValueForKey(superKey)
        if superContent != nil {
            var error:NSError?
            var superxmlDoc = AEXMLDocument(xmlString:superContent!,error:&error)
            var children = superxmlDoc?.rootElement[key as String]
            return self.getArr(children)
        }
        return nil
    }
    
    
    
    override func getIntValueForKey(key: NSString) -> Int? {
        
        if self.getParseContent() != nil {
            return self.getParseContent()?.getIntValueForKey(key)
        }
        
        var value = self.getStringValueForKey(key)
        return value?.integerValue
    }
    override func getBoolValueForKey(key:NSString) -> Bool?
    {
        if self.getParseContent() != nil {
            return self.getParseContent()?.getBoolValueForKey(key)
        }
        
        var value = self.getStringValueForKey(key)
        if value != nil && value!.isEqualToString("true"){
            return true
        }
        return false
    }

    
    
    
    private func getArr(xmlEle:AEXMLElement?) -> NSMutableArray?{
        if xmlEle == nil {
            return nil
        }
        var arr = NSMutableArray()
               
        var allEles = xmlEle!.all
        for e in allEles {
            var  subXMLStr = e.xmlString
            arr.addObject(subXMLStr)
        }
        return arr
    }
    
}
