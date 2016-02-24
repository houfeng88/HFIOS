//
//  RLParseContent.swift
//  rlterm3
//
//  Created by houfeng on 12/5/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import Foundation
import RLNetwork
class RLParseContentFactory:NSObject{
    
    class func createContextByString(str:NSString?) ->RLParseContent?{
        if rl_prase_type == .XML {
            if str != nil {
                var error:NSError?
                var xml =  AEXMLDocument(xmlString:str!,error: &error)
                return RLParseXMLContent(xmlEle: xml?.rootElement)
            }else{
                return nil
            }
            
        }else if rl_prase_type == .JSON{
            return nil
        }
        return nil
    }
    
    
    class func createContextByData(data:NSData?) ->RLParseContent?{
        if rl_prase_type == .XML {
            if data != nil {
                var error:NSError?
                var xml =  AEXMLDocument(xmlData:data!,error: &error)
                return RLParseXMLContent(xmlEle: xml?.rootElement)
            }else{
                return nil
            }
            
        }else if rl_prase_type == .JSON{
            return nil
        }
        return nil
    }
    
}


class RLParseContent{
     func getStringValueForKey(key:NSString)->NSString?{
        return nil
    }
    
     func getIntValueForKey(key:NSString)->Int?{
        return nil
    }
    
    func getBoolValueForKey(key:NSString) -> Bool?
    {
        return false
    }
    
     func getArrayValueForyKey(key:NSString)-> NSMutableArray?{
        return nil
    }
    
     func getParsedString()-> NSString?{
        return nil
    }
    
    func getParseStringByKey(key:NSString)->NSString?{
        return nil
    }
    
    func getArrayValueFromSuperKey(key:NSString,superKey:NSString) -> NSMutableArray?{
        
        return nil
    }

}

class RLParseJSONContent:RLParseContent {
    override func getStringValueForKey(key:NSString)->NSString?{
        return nil
    }
    
    override func getIntValueForKey(key:NSString)->Int?{
        return nil
    }
    override
    func getBoolValueForKey(key:NSString) -> Bool?
    {
        return false
    }
    
    override func getArrayValueForyKey(key:NSString)-> NSMutableArray?{
        return nil
    }
    
    override func getParsedString()-> NSString?{
        return nil
    }
    override
    func getParseStringByKey(key:NSString)->NSString?{
        return nil
    }
    override
    func getArrayValueFromSuperKey(key:NSString,superKey:NSString) -> NSMutableArray?{
        
        return nil
    }
    
}


class RLParseXMLContent:RLParseContent{
    
    private var xml:AEXMLElement?
    
    init(xmlEle:AEXMLElement?) {
        super.init()
        self.xml = xmlEle
    }
    
    override func getStringValueForKey(key:NSString)->NSString?{
        return xml?[key as! String]?.value
    }
    
    override func getIntValueForKey(key:NSString)->Int?{
        var value = self.getStringValueForKey(key)
        return value?.integerValue
    }
    
    override func getBoolValueForKey(key:NSString) -> Bool?
    {
        var value = self.getStringValueForKey(key)
        if value != nil && value!.isEqualToString("true"){
            return true
        }
        return false
    }
    
    override func getArrayValueForyKey(key:NSString)-> NSMutableArray?{
        var arr:NSMutableArray? = NSMutableArray()
        var children = xml?[key as String]
        if children != nil {
            for ele in children!.all{
                var c = RLParseXMLContent(xmlEle: ele)
                arr?.addObject(c)
            }
        }
        return arr
    }
    override
    func getParsedString()-> NSString?{
        return xml?.xmlString
    }
    
    override func getParseStringByKey(key:NSString)->NSString?{
        return xml?[key as! String]?.xmlString
    }
    
    override func getArrayValueFromSuperKey(key:NSString,superKey:NSString) -> NSMutableArray?{
        var arr:NSMutableArray?
        var superEle = xml?[superKey as String]
        if superEle != nil {
            var children =  superEle![key as String]
            if children != nil {
                for ele in children!.all{
                    var c = RLParseXMLContent(xmlEle: ele)
                    arr?.addObject(c)
                }
            }
            
        }
        return arr
    }
    
}
