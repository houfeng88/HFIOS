//
//  RLJSONNode.swift
//  rlterm3
//
//  Created by houfeng on 11/28/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import RLNetwork
typealias JSON = RLNetwork.JSON
class RLJSONComponent: RLParseComponet {
    private var json:JSON = JSON.nullJSON
    override init(content c:NSString){
        super.init(content:c)
        var error:NSError?
       json = JSON(jsonString: c, error: &error)
        
    }
    
    override init(parseContent:RLParseContent?){
        super.init(parseContent:parseContent)
    }
    
    override func getStringValueForKey(key:NSString)->NSString?{
       return nil
    }
    
    override func getIntValueForKey(key:NSString)->Int?{
        return nil
    }
    
    override func getBoolValueForKey(key:NSString) -> Bool?
    {
        return false
    }
    
    override func getArrayValueForyKey(key:NSString)-> NSMutableArray?{
        return nil
    }

}
