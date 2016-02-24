//
//  RLSetConfigItems.swift
//  rlterm3
//
//  Created by houfeng on 11/25/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import Foundation
import RLUtillties
let RLConfigItemType_textfield = "textfield"
let RLConfigItemType_segment = "segment"
let RLConfigItemType_switch = "switch"

let RLConfigItemRegtypeIP = "ip"
let RLConfigItemRegtypeINT = "int"
let RLConfigItemRegtypeFLOAT = "float"

public class RLConfigItem{
    public var itemName:NSString?
    public var itemKey:NSString?
    public var itemType:NSString?
    public var itemFrom:NSString?
    public var itemRegtype:NSString?
    public init(){
        
    }
}


public class RLConfigTextFieldItem : RLConfigItem{
    
}

public class RLConfigSwitchItem:RLConfigItem{
    
}

public class  RLSegmentItem :NSObject{
  public  var name:NSString?
  public  var value:NSString?
}


public class RLConfigSegmentItem:RLConfigItem{
    public var segmentItems:NSMutableArray?
    override init() {
        super.init()
        segmentItems = NSMutableArray()
    }
}


public class RLConfigGroup{
    public var groupName:NSString?
    public var items:NSMutableArray!
    
    init(){
        items =  NSMutableArray(capacity: 10)
    }
    
    internal func addItem(item:RLConfigItem){
        items.addObject(item)
    }
    
    
    internal func itemAtIndex(index:Int) -> RLConfigItem? {
        if items.count > index {
            return (items.objectAtIndex(index) as! RLConfigItem)
        }
        return nil
    }
}


class RLConfigSettingTable{
    
    private var _groups:NSMutableArray!

    internal func getGroups() -> NSMutableArray {
        return _groups
    }

    init(jsonFile:NSString){
        _groups = NSMutableArray(capacity: 10)
        
        var configData:NSData? = NSData(contentsOfFile: jsonFile as String)
        var error:NSError?
        var josn:AnyObject? = NSJSONSerialization.JSONObjectWithData(configData!, options: NSJSONReadingOptions(), error: &error)
        
        if let dic = josn as? NSDictionary {
            
            var groups:NSArray?  = dic.objectForKey("groups")  as? NSArray
            
            if groups != nil  {
                
                for  g in groups! {
                    
                    if let group = g as? NSDictionary {
                        
                        var groupname = group.objectForKey("groupname") as? NSString
                        
                        var gObj =  RLConfigGroup()
                        gObj.groupName = groupname
                        
                        var items = group.objectForKey("items") as? NSArray
                        
                        if items != nil {
                            
                            for i in items! {
                                if let item = i as? NSDictionary {
                                    var iObj:RLConfigItem?
                                    
                                    var  itemtype = item.objectForKey("itemtype") as? NSString
                                    var  itemname = item.objectForKey("itemname") as? NSString
                                    var  itemkey = item.objectForKey("itemkey") as? NSString
                                    var  itemFrom = item.objectForKey("itemfrom") as? NSString
                                    var  itemRegtype = item.objectForKey("itemRegtype") as? NSString
                                    
                                    if itemtype!.isEqualToString("textfield") {
                                        
                                        iObj = RLConfigTextFieldItem()
                                        
                                        
                                        
                                    }else if itemtype!.isEqualToString("segment") {
                                        
                                        iObj = RLConfigSegmentItem()
                                        var seg = iObj as! RLConfigSegmentItem
                                        
                                        var segitems =  item.objectForKey("segmentitems") as? NSArray
                                        
                                        for segitem in  segitems! {
                                            
                                            if let segDic = segitem as? NSDictionary
                                            {
                                                
                                                var name = segDic.objectForKey("name") as! NSString
                                                var value =   segDic.objectForKey("value") as! NSString
                                                
                                                var it = RLSegmentItem()
                                                it.name = name
                                                it.value = value
                                                seg.segmentItems?.addObject(it)
                                                
                                                
                                            }
                                            
                                            
                                        }
                                        
                                    }else if itemtype!.isEqualToString("switch"){
                                        
                                        iObj = RLConfigSwitchItem()
                                        
                                    }
                                    
                                    if iObj != nil {
                                        
                                        iObj!.itemType = itemtype
                                        iObj!.itemName = RL_LocalizedString(itemname!)
                                        iObj!.itemKey = itemkey
                                        iObj!.itemFrom = itemFrom
                                        iObj!.itemRegtype = itemRegtype
                                        
                                        gObj.addItem(iObj!)
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                               
                                
                            }
                            
                        }
                        
                        
                        self._groups.addObject(gObj)
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
        
        
        
    }
    
}



