//
//  RLNode.swift
//  rlterm3
//
//  Created by houfeng on 11/28/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit

public enum RL_DATA_PRASE_TYPE:NSString{
    case XML = "xml"
    case JSON = "json"
}


public class RLKeyValue:NSObject{
    public var key:NSString?
    public var value:AnyObject?
}

let rl_prase_type:RL_DATA_PRASE_TYPE = .XML

public class RLNode: NSObject {
    private var praseCommponet:RLParseComponet?

    
    override init() {
        super.init()
    }

    convenience init(xml x:NSString){
        self.init()
        self.praseCommponet = RLXMLComponent(content: x)
        self.parse()
    }
    convenience init(json j:NSString){
        self.init()
        self.praseCommponet = RLJSONComponent(content: j)
        self.parse()
    }
    
    convenience init(content c:NSString){
        if rl_prase_type == .XML {
            self.init(xml:c)
        }else{
            self.init(json:c)
        }
    }
    
    
    convenience init(parseXMLContext x:RLParseContent?){
         self.init()
        self.praseCommponet = RLXMLComponent(parseContent: x)
        self.parse()

    }
    convenience init(parseJSONContext j:RLParseContent?){
        self.init()
        self.praseCommponet = RLJSONComponent(parseContent:j)
        self.parse()

    }
    
    convenience init(parseContext c:RLParseContent?){
        if rl_prase_type == .XML {
            self.init(parseXMLContext:c)
        }else{
            self.init(parseJSONContext:c)
        }
    }

    
    
    
    func getPraseCommpont()->RLParseComponet?{
        return self.praseCommponet
    }
    
    func parse(){
        
    }
    
    func toXMLString() -> NSString?{
        return nil;
    }
    
    func toJSONString() -> NSString?{
        return nil 
    }
    
    func toContentString() -> NSString?{
        if rl_prase_type == .XML {
            return toXMLString()
        }else{
           return toJSONString()
        }
    }
    
}