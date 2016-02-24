//
//  RLConfigCellView.swift
//  rlterm3
//
//  Created by houfeng on 11/26/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import Foundation
import UIKit
import RLConfiguration
import RLUtillties
class RLConfigCellView:UITableViewCell,UITextFieldDelegate{
    private var _lastOffSet:CGPoint?
    private var _textField:UITextField?
    private var _switch:UISwitch?
    private var _segment:UISegmentedControl?
    private var _item:RLConfigItem?
    
    internal var superTable:UITableView?
    
    override  init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.textLabel!.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        _lastOffSet = CGPointZero
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    internal func setItem(item:RLConfigItem){
        
        self.contentView.removeAllSubViews()
        _item = item
        if _item != nil {
            self.textLabel!.text = _item?.itemName as? String
            
            if _item is RLConfigTextFieldItem {
                
                var textItem = _item as? RLConfigTextFieldItem
                var textField =  UITextField(frame: CGRectMake(400, 5, 300,self.frame.size.height-10))
                textField.borderStyle = UITextBorderStyle.RoundedRect
                self.contentView.addSubview(textField)
                var  regType =  textItem?.itemRegtype
                if regType !=  nil {
                    if regType!.isEqualToString(RLConfigItemRegtypeINT) || regType!.isEqualToString(RLConfigItemRegtypeFLOAT) {
                        textField.keyboardType = UIKeyboardType.NumberPad
                        
                    }
                }
               
                textField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
                textField.delegate = self
                _textField = textField
                textField.clearsOnBeginEditing = false
                var key = textItem?.itemKey
                var value = self.getConfig().getStringValueForKey(key!)
                textField.text = value as? String
                
                
                
                var okButton:UIButton =  UIButton.buttonWithType(UIButtonType.System) as! UIButton
                okButton.frame = CGRectMake(720, 5, 80, self.frame.size.height-10)
                okButton.addTarget(self, action: Selector("textFieldSetting"), forControlEvents: UIControlEvents.TouchUpInside)
                okButton.setTitle(RL_LocalizedString("Apply") as String, forState: UIControlState.Normal)
                self.contentView.addSubview(okButton)
                
                
                
            }else if _item  is RLConfigSwitchItem {
                
                var sw = UISwitch(frame: CGRectMake(735, 6, 100, 30))
                self.contentView.addSubview(sw)
                sw.addTarget(self, action: Selector("switchSetting"), forControlEvents: UIControlEvents.ValueChanged)
                var key = _item?.itemKey
                sw.setOn(self.getConfig().getBoolValueForKey(key!), animated: false)
                
                
            }else if _item is RLConfigSegmentItem {
                
                var seg = _item as? RLConfigSegmentItem
                
                if seg != nil {
                    var index = 0
                    var finded = false
                    var arr = seg!.segmentItems
                    var key = seg!.itemKey
                    var itemNames =   NSMutableArray()
                    var segStr = self.getConfig().getStringValueForKey(key!)
                    
                    for i in  arr! {
                        if let item = i as? RLSegmentItem {
                            if item.value!.isEqualToString(segStr! as String) {
                                finded = true
                            }
                            
                            itemNames.addObject(item.name!)
                        }
                        
                        if !finded {
                           index++
                        }
                        
                    }
                    var count = itemNames.count
                    var segCtl =   UISegmentedControl(items: itemNames as [AnyObject])
                    self.contentView.addSubview(segCtl)
                    segCtl.addTarget(self, action: Selector("segSelect:"), forControlEvents: UIControlEvents.ValueChanged)
                    segCtl.frame = CGRectMake(420, 6, CGFloat(count) * 100, 30)
                    segCtl.selectedSegmentIndex = index
                    
                    
                }
                
                
            }
        }
        
        
    }
    
    func getConfig()->RLConfig {
        var from = _item?.itemFrom
        if from != nil && from!.isEqualToString("termconfig") {
            return RLConfig.shareConfig.getTermConfig()
        }
         return RLConfig.shareConfig.getMakerConfig()
        
     }
    
    func textFieldDidBeginEditing(textField: UITextField) {
   
        if self.superTable != nil {
            if self.frame.origin.y > self.superTable!.frame.size.height / 2  - 100{
                self.superTable!.setContentOffset(CGPointMake(0, self.frame.origin.y), animated: false)
            }
        }
       
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if self.superTable != nil {
            self.superTable!.setContentOffset(_lastOffSet!, animated: false)
        }
    }
    
    func textFieldSetting(){
        
        RLUtilities.getHUD().labelText = RL_LocalizedString("updateing")
        RLUtilities.getHUD().show(true)
        var queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, {
            if self._textField != nil  {
                var str = self._textField?.text
                if str !=  nil && !str!.isEmpty {
                    var key = self._item?.itemKey
                    self.getConfig().setValueForKey(str!, key: key!)
                }
              
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                RLUtilities.getHUD().labelText = RL_LocalizedString("succeed")
                RLUtilities.getHUD().hide(true, afterDelay: 0.5)
            })
        })
    }
    
    
    func switchSetting(){
        
        RLUtilities.getHUD().labelText = RL_LocalizedString("updateing")
        RLUtilities.getHUD().show(true)
        var queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, {
            
            var key = self._item?.itemKey
            var value =  self.getConfig().getBoolValueForKey(key!)
            self.getConfig().setBoolValueForKey(!value, key: key!)
            dispatch_async(dispatch_get_main_queue(),{
                 RLUtilities.getHUD().labelText = RL_LocalizedString("succeed")
                 RLUtilities.getHUD().hide(true, afterDelay: 0.5)
            })
        })
    }
    
    func segSelect(ctl:UISegmentedControl){
        RLUtilities.getHUD().labelText = RL_LocalizedString("updateing")
        RLUtilities.getHUD().show(true)
        var queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, {
            var key = self._item?.itemKey
            var seg = self._item as! RLConfigSegmentItem
            var arr = seg.segmentItems
            if arr != nil {
                var index = ctl.selectedSegmentIndex
                if index < arr!.count {
                    var it =  arr!.objectAtIndex(index)  as! RLSegmentItem
                    var value = it.value
                    self.getConfig().setValueForKey(value!, key: key!)
                }
            }
            dispatch_async(dispatch_get_main_queue(),{
                RLUtilities.getHUD().labelText = RL_LocalizedString("succeed")
                RLUtilities.getHUD().hide(true, afterDelay: 0.5)
            })
            
        })

    }
    
}
