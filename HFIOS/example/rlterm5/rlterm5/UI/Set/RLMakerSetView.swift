//
//  RLMakerSetView.swift
//  rlterm3
//
//  Created by houfeng on 11/28/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit
import RLUtillties
class RLMakerSetView: RLSetView, UITableViewDelegate, UITableViewDataSource {

    var tableView:UITableView!
    var tableData:RLConfigSettingTable!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var file = "\(RLUtilities.getBundleDirecory())/RLConfigSetting.json"
        tableData = RLConfigSettingTable(jsonFile: file)
        
        
        tableView = UITableView(frame: self.bounds)
        self.addSubview(tableView)
       
        tableView.registerClass(RLConfigCellView.classForCoder(), forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        var g = tableData.getGroups()[section] as! RLConfigGroup
        return g.groupName as? String
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.getGroups().count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        var g = tableData.getGroups()[section] as! RLConfigGroup
        return g.items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40.0
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! RLConfigCellView
        cell.superTable = tableView
        var g = tableData.getGroups()[indexPath.section] as! RLConfigGroup
        var item = g.itemAtIndex(indexPath.row)
        if(item != nil ){
            cell.setItem(item!)
        }
        return cell
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */


}
