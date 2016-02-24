//
//  RLParseComponet.swift
//  rlterm3
//
//  Created by houfeng on 11/28/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit






class RLParseComponet: RLComponent {
    private var content:NSString?
    private var parseContent:RLParseContent?
    
    internal func getContent() -> NSString? {
        return self.content
    }
    internal func getParseContent() -> RLParseContent?{
        return parseContent
    }
    init(content:NSString){
        self.content = content
        super.init()
    }
    
    init(parseContent:RLParseContent?){
        
        self.parseContent = parseContent
        super.init()
    }
    
    func getStringValueForKey(key:NSString)->NSString?{
        return self.parseContent?.getStringValueForKey(key)
    }
    
    func getIntValueForKey(key:NSString)->Int?{
        return self.parseContent?.getIntValueForKey(key)
    }
    
    func getBoolValueForKey(key:NSString) -> Bool?
    {
        return self.parseContent?.getBoolValueForKey(key)
    }
    
    func getArrayValueForyKey(key:NSString)-> NSMutableArray?{
        return self.parseContent?.getArrayValueForyKey(key)
    }
    
    func getParsedString()-> NSString?{
        return self.parseContent?.getParsedString()
    }
    
    func getParseStringByKey(key:NSString)->NSString?{
        return self.parseContent?.getParseStringByKey(key)
    }
    
    func getArrayValueFromSuperKey(key:NSString,superKey:NSString) -> NSMutableArray?{
        
        return self.getArrayValueFromSuperKey(key, superKey: superKey)
    }
    
    
}
