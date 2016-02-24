//
//  RLProductTree.swift
//  rlterm3
//
//  Created by houfeng on 12/1/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit

public class RLRequireSkill:RLNode{
    public var ID:NSString?
    override func parse(){
         var parser = self.getPraseCommpont()
         self.ID = parser?.getStringValueForKey("id")
    }
}
public class RLProduct:RLNode{
    public var ID:NSString?
    public var name:NSString?
    public var price:Int? = 0
    public var minute:Int? = 0
    public var oder:Int? = -1
    public var type:NSString? = "0"
   
    
    public var isCategory:Bool = false
    public var isProduct:Bool = true
    public var isSetProduct:Bool = false
    public var isRvProduct:Bool? = false
    
    public var children:NSMutableArray = NSMutableArray()
    public var requireSkills:NSMutableArray = NSMutableArray()
    public var parent:RLProduct? = nil
    public var root:RLProductTree? = nil
    override func parse() {
        var parser = self.getPraseCommpont()
        
        var contextStr = self.getPraseCommpont()?.getParsedString()
        println(contextStr)
        
        
        self.ID = parser?.getStringValueForKey("id")
        self.name = parser?.getStringValueForKey("name")
        self.oder = parser?.getIntValueForKey("oder")
        
        
        self.price = parser?.getIntValueForKey("price")
        self.minute = parser?.getIntValueForKey("minute")
        
        self.type = parser?.getStringValueForKey("type")
       
        self.isRvProduct = parser?.getBoolValueForKey("isRvProduct")
        var skills =  parser?.getArrayValueFromSuperKey("requireSkill", superKey: "requireSkills")
        if skills != nil {
            
            for subContent in skills! {
                var skill:RLRequireSkill!
                if subContent is NSString {
                    skill = RLRequireSkill(content:subContent as! NSString)
                }else if subContent is RLParseContent {
                    skill = RLRequireSkill(parseContext: subContent as? RLParseContent)
                }
                self.requireSkills.addObject(skill)
            }
            
        }
        
        
        var subCategory = parser?.getArrayValueForyKey("subCategory")
        if subCategory != nil {
            for subContent in subCategory! {
                var subP:RLProduct!
                if subContent is NSString {
                    subP = RLProduct(content:subContent as! NSString)
                }else if subContent is RLParseContent {
                    subP = RLProduct(parseContext: subContent as? RLParseContent)
                }
                subP.isCategory = true
                subP.parent = self
                subP.root = self.root
                if subP.ID != nil {
                    self.root?.addProductForKey(subP, key: subP.ID!)
                }
                self.children.addObject(subP)
                
            }
        }
        
        
        var products = parser?.getArrayValueForyKey("product")
        if products != nil {
            for subContent in products! {
                var subP:RLProduct!
                if subContent is NSString {
                    subP = RLProduct(content:subContent as! NSString)
                }else if subContent is RLParseContent {
                    subP = RLProduct(parseContext: subContent as? RLParseContent)
                }
                subP.isProduct = true
                subP.parent = self
                subP.root = self.root
                if subP.ID != nil {
                    self.root?.addProductForKey(subP, key: subP.ID!)
                }
                self.children.addObject(subP)
                
            }
        }
        
    }
}
public class RLProductTree: RLProduct {
    private var allProduct:NSMutableDictionary = NSMutableDictionary()
    override func parse() {
        self.ID = "-1"
        self.name = "root"
        self.isCategory = true
        self.isProduct = false
       
        var parser = self.getPraseCommpont()
        var arr = parser?.getArrayValueForyKey("category")
        if arr != nil {
            for content in  arr! {
                var p:RLProduct!
                
                if content is NSString {
                    p = RLProduct(content:content as! NSString)
                }else if content is RLParseContent {
                    p = RLProduct(parseContext: content as? RLParseContent)
                }
                p.parent =  self
                self.root = self
                if p.ID != nil {
                    self.root?.addProductForKey(p, key: p.ID!)
                }
                self.children.addObject(p)
            }
            
        }
        
        
    }
    
    
    public func addProductForKey(p:RLProduct,key:NSString){
        self.allProduct.setObject(p, forKey: key)
    }
    
   public func getProductForKey(key:NSString) -> RLProduct?{
        return self.allProduct.objectForKey(key)  as? RLProduct
    }

}
