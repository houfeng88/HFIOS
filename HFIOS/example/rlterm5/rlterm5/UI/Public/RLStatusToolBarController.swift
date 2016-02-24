//
//  RLStatusToolBarController.swift
//  rlterm3
//
//  Created by houfeng on 11/24/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit

class RLStatusToolBarController: UIViewController {

    @IBOutlet weak var statusTitleLabel: UILabel!
    
   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

   required  init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
     
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setStatusTitle(title:String){
        self.statusTitleLabel.text = title
    }
    
    
    @IBAction func goBack(sender: AnyObject) {
        
        RLControllerManager.shareManager.goBack()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
