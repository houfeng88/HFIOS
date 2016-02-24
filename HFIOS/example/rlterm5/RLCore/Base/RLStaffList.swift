//
//  RLStaffList.swift
//  rlterm3
//
//  Created by houfeng on 12/1/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit

public class RLStaff:RLNode{
    public var name:NSString?
    public var furigana:NSString?
    public var ID:NSString?
    override  func parse() {
        self.name = self.getPraseCommpont()?.getStringValueForKey("name")
        self.furigana = self.getPraseCommpont()?.getStringValueForKey("furigana")
        self.ID = self.getPraseCommpont()?.getStringValueForKey("id")
    }
}
    

public class RLStaffList: RLNode {
    private var rootXMLString = "staff"
    private var onLineList:NSMutableArray?
    private var demoList:NSMutableArray?
    
    override  func parse() {
        self.onLineList = NSMutableArray()
        var parser = self.getPraseCommpont()
        var contextArr = parser?.getArrayValueForyKey(rootXMLString)
        
        if contextArr != nil {
            var s:RLStaff?
            for straffContent in contextArr! {
                if straffContent is NSString{
                    s = RLStaff(content:straffContent as! NSString)
                }else if straffContent is RLParseContent {
                    s = RLStaff(parseContext: straffContent as? RLParseContent)
                }
                if s != nil{
                     self.onLineList?.addObject(s!)
                }
                
            }
        }
       
        
        self.demoList = NSMutableArray()
        var staffid = 10001
        var staffName = 65
        for var i = 0; i < 3; i++ {
            var staff = RLStaff()
            staff.name = "テスト君\(String(UnicodeScalar(staffName + i)))"
            staff.ID = "\(staffid + i)"
            staff.furigana = "テストクン\(i)"
            self.demoList?.addObject(staff)
        }
            
        
    }
    
}
