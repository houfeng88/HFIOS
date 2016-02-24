//
//  RLUtilities.swift
//  rlterm3
//
//  Created by houfeng on 11/24/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import Foundation
import UIKit
import RLConfiguration
typealias RLConfig = RLConfiguration.RLConfig

public let RL_dateFormatter:NSDateFormatter! = NSDateFormatter()

public func RL_LocalizedString(key:NSString)->NSString{
    return  NSLocalizedString(key as String,comment: "")
}

public let RL_SCREEN_WIDTH:CGFloat =  1024
public let RL_SCREEN_HEIGHT:CGFloat = 768


public extension UIView{
    
    public func removeAllSubViews(){
        
        for view  in self.subviews{
            if  view is UIView {
                let subView = view as! UIView
                subView.removeFromSuperview()
            }
        }
    }
    
   public func setX(x:CGFloat){
        setXY(x, y: self.frame.origin.y)
    }
    
   public func setY(y:CGFloat){
        setXY(self.frame.origin.x, y: y)
    }
    
    
  public  func setXY(x:CGFloat,y:CGFloat){
        self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height)
    }
    
    
  public func setWidth(width:CGFloat){
        setSize(CGSizeMake(width, self.frame.size.height))
    }
    
  public  func setHeight(height:CGFloat){
        setSize(CGSizeMake(self.frame.size.width, height))
    }
    
  public  func setSize(size:CGSize){
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height)
    }
    
}

var RL_STORYBOARD:UIStoryboard?

public class RLUtilities{
    
    public class func  getURLWithKey(key:String)->String?{
        var url:String?
        var server = RLConfig.shareConfig.getMakerConfig().getStringValueForKey("rl_comm.server")
        var appName = RLConfig.shareConfig.getStringValueForKey("rl_comm.app_name")
        var actionPath = RLConfig.shareConfig.getStringValueForKey("rl_comm.action_path.\(key)")
        url = "https://\(server!)/\(appName!)\(actionPath!)"
        println(url)
        return url
        
    }
    
    public class func getLocalTimeString()->String{
        var date  = NSDate()
        getRLDataFormatter().dateFormat  = "yyyy-MM-dd HH:mm:ss"
        return  getRLDataFormatter().stringFromDate(date)
    }
    
   public class func getRLDataFormatter() -> NSDateFormatter{
        
        return RL_dateFormatter
    }
    

    
   public class func getBundleDirecory() ->NSString{
        return NSBundle.mainBundle().bundlePath
    }
    
    
   public class func getCopyRightLabelWithFrame(frame:CGRect) -> UILabel{
        var label:UILabel = UILabel(frame: frame)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        
//        var version = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey) as! NSString
        var version = NSBundle.mainBundle().objectForInfoDictionaryKey(String(kCFBundleVersionKey)) as! String
        var buildinfo = NSDictionary(contentsOfFile: getBundleDirecory().stringByAppendingFormat("/buildinfo.plist") as! String)
        var svn_ver = buildinfo!.objectForKey("svn_revision") as! NSString
        var build_time = buildinfo?.objectForKey("build_timestamp") as! NSString
        var infoStr = "(iPos v\(version))[r\(svn_ver)] \(build_time)"
        var copyright = RL_LocalizedString("copyright")
        label.text = "\(copyright)  \(infoStr)"
        return label
        
    }
    
   public class func versions() -> String{
        return "0x0118"
    }
    
    
    
  public  class func getRLMainStroyboard() -> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
   public class func appendXML(content:NSString?,around:NSString) -> NSString?{
        
       return "<\(around)>\(content)</\(around)>"
    }
    
    
   public class func getHUD()->RLHUD{
        struct RLSingeton{
            static let hud:RLHUD = {
                var hud = RLHUD(window: UIApplication.sharedApplication().keyWindow!)
                hud.minSize = CGSizeMake(135, 135)
                hud.minShowTime = 0.2
                hud.mode = RLHUDMode.Indeterminate
                hud.customView = nil
                hud.removeFromSuperviewOnHide = false
                return hud
                }()
        }
        var hud = RLSingeton.hud
        UIApplication.sharedApplication().keyWindow?.addSubview(hud)
        return hud
    }
    
    
}