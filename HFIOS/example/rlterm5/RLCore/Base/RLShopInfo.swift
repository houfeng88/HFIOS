//
//  RLShopInfo.swift
//  rlterm3
//
//  Created by houfeng on 11/28/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit

public class RLShopInfo: RLNode {
    private var rootXMLString = "shopInfo"
    public var name:NSString?
    public var formalName:NSString?
    public var ID:NSString?
    public var telephone:NSString?
    public var brandId:NSString?
    public var  shopAddress:NSString?
    public var scName:NSString?
    override  func parse(){
       self.ID   = self.getValue("id")
       self.name =  self.getValue("name")
       self.formalName = self.getValue("formalName")
       self.telephone =  self.getValue("telephone")
       self.brandId =   self.getValue("brandId")
       self.shopAddress = self.getValue("shopAddress")
        self.scName = self.getValue("scName")
        if self.formalName != nil {
            self.formalName = self.name
        }
        
    }
    
    func getValue(key:NSString) -> NSString?{
         var parser = self.getPraseCommpont()
        return parser?.getStringValueForKey(key)
    }
    
    
    
}
