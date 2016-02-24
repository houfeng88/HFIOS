//
//  HFUserNotification.swift
//  HFIOS
//
//  Created by houfeng on 16/1/11.
//  Copyright © 2016年 houfeng. All rights reserved.
//

import Foundation
import UIKit
class HFUserNotification{
    func registerNotification(){
        // #available(iOS 8, *)
        let types:UIUserNotificationType = ([.Badge , .Alert , .Sound])
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
    }

}
