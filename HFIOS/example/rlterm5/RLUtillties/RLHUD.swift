//
//  RLHUD.swift
//  rlterm3
//
//  Created by houfeng on 11/26/14.
//  Copyright (c) 2014 houfeng. All rights reserved.
//

import UIKit

let  kPadding:CGFloat = 4.0
let  kLabelFontSize:CGFloat = 16.0
let kDetailsLabelFontSize:CGFloat = 12.0

public enum RLHUDMode:Int{
    case Indeterminate
    case Determinate
    case AnularDeterminate
    case CustomerView
    case Text
}

public enum RLHUDAnimation:Int{
    case Fade
    case Zoom
    case ZoomOut
    case ZoomIn
}

public class RLHUD:UIView{
    internal var completionBlock:((Void)->Void)?
    var methodForExecution:Selector?
    var targetForExecution:AnyObject?
    var objectForExecution:AnyObject?
    public var removeFromSuperviewOnHide:Bool = false
    public var animationType:RLHUDAnimation?
    public var _mode:RLHUDMode = RLHUDMode.Text
    public var mode:RLHUDMode{
        get{
            return _mode
        }
        set{
            _mode = newValue
            self.setKeypath("mode")
        }
    }
    var _customView:UIView? = UIView()
    public var customView:UIView?{
        get{
            return _customView
        }
        set{
            
            _customView = newValue
            self.setKeypath("customView")
        }
    }
    var _labelText:NSString = ""
    public var labelText:NSString{
        get{
            return _labelText
        }
        set{
            _labelText = newValue
            if label != nil {
                label?.text = _labelText as String
                self.setKeypath("labelText")
            }
        }
    }
    
    var _detailsLabelText:NSString?
    public var detailsLabelText:NSString?{
        get{
            return _detailsLabelText
        }
        set{
            _detailsLabelText = newValue
            self.setKeypath("detailsLabelText")
        }
    }
    
    var _labelFont = UIFont.boldSystemFontOfSize(kLabelFontSize)
    public var labelFont:UIFont{
        get{
            return _labelFont
        }
        set{
            _labelFont = newValue
            self.setKeypath("labelFont")
            
        }
    }
    
    var _detailsLabelFont = UIFont.boldSystemFontOfSize(kDetailsLabelFontSize)
    public var detailsLabelFont:UIFont{
        get{
            return _detailsLabelFont
        }
        set{
            _detailsLabelFont = newValue
            self.setKeypath("detailsLabelFont")
            
        }
    }
    
    private var _progress:CGFloat = 0.0
    public var progress:CGFloat {
        get{
            return _progress
        }
        set{
            _progress = newValue
            self.setKeypath("progress")
        }
    }
    
    public var opacity:CGFloat = 0.8
    public var color:UIColor?
    var xOffset:CGFloat = 0.0
    var yOffset:CGFloat = 0.0
    var dimBackground = false
    var margin:CGFloat = 20.0
    var graceTime:NSTimeInterval = 0.0
    var graceTimer:NSTimer?
    public var minShowTime:NSTimeInterval = 0.0
    var minShowTimer:NSTimer?
    public var minSize = CGSizeZero
    public var square = false
    public var size:CGSize = CGSizeZero
    var taskInProgress = false
    var rotationTransform = CGAffineTransformIdentity
    var label:UILabel?
    var detailsLabel:UILabel?
    var useAnimation:Bool = true
    var showStarted:NSDate?
    var isFinished:Bool = false
    var _indicator:UIView? = UIView()
    var indicator:UIView?{
        get{
            return _indicator
        }
        set{
            _indicator?.removeFromSuperview()
            _indicator = newValue
            if _indicator != nil {
                self.addSubview(_indicator!)
            }
        }
    }
    
    deinit{
        self.unregisterFromNotifications()
        
    }
    public func showHUDAddedTo(view aView:UIView ,animated anim:Bool) -> RLHUD{
        var hud = RLHUD(view: aView)
        aView.addSubview(hud)
        hud.show(anim)
        return hud
    }
    
    func hideHUDForView(view aView:UIView, animated anim:Bool) -> Bool{
        
        var hud = RLHUD.HUDForView(view: aView)
        if hud != nil {
            hud!.removeFromSuperviewOnHide = true
            hud!.hide(anim)
            
            return true
        }
        
        return false
    }
    
    
    class func hideAllHUDsForView(view aView:UIView, animated anim:Bool) -> Int{
        
        var huds = allHUDsForView(view: aView)
        if huds !=   nil {
            
            for v  in  huds! {
                if let  hud   = v as? RLHUD {
                    
                    hud.removeFromSuperviewOnHide = true
                    hud.hide(anim)
                }
            }
            return huds!.count
            
        }
        
        return  0
    }
    
    
    class func HUDForView(view aView:UIView) ->RLHUD?{
        var hud:RLHUD?
        for v in aView.subviews {
            if v is RLHUD {
                hud = v as? RLHUD
            }
        }
        return hud
    }
    
    
    class func allHUDsForView(view aView:UIView) -> NSArray?{
        
        var huds = NSMutableArray()
        
        for v in aView.subviews {
            if v is RLHUD {
                huds.addObject(v)
            }
        }
        
        return huds
    }
    
    
    
    
    
    convenience init(view aView:UIView) {
        
        self.init(frame: aView.bounds)
        if aView is UIWindow {
            self.setTransformForCurrentOrientation(false)
        }
    }
    
    convenience init(window aWindow:UIWindow){
        self.init(view: aWindow)
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizingMask =   .FlexibleTopMargin | .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin;
        
        self.opaque  = false
        self.backgroundColor = UIColor.clearColor()
        self.alpha = 0.0
        
        self.setupLabels()
        self.updateIndicators()
        self.registerForNotifications()
        
        self.setNeedsDisplay()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    public func show(animated:Bool){
        useAnimation = animated
        if self.graceTime > 0.0 {
            self.graceTimer =  NSTimer.scheduledTimerWithTimeInterval(self.graceTime, target: self, selector: Selector("handleGraceTimer:"), userInfo: nil, repeats: false)
            
        }else{
            self.setNeedsDisplay()
            self.showUsingAnimation(useAnimation)
        }
        
    }
    
    public func hide(animated:Bool){
        useAnimation = animated
        
        if self.minShowTime > 0.0 && showStarted != nil {
            var interv =  NSDate().timeIntervalSinceDate(showStarted!)
            if interv < self.minShowTime {
                
                self.minShowTimer =  NSTimer.scheduledTimerWithTimeInterval(self.minShowTime - interv, target: self, selector: Selector("handleMinShowTimer:"), userInfo: nil, repeats: false)
                
                return
            }
            
        }
        
        
        self.hideUsingAnimation(useAnimation)
    }
    
    
    public func hide(animated:Bool, afterDelay:NSTimeInterval){
        
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(afterDelay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            
            NSThread.detachNewThreadSelector(Selector("hideDelayed:"), toTarget: self, withObject: NSNumber(bool: animated))
            
        
        })
        
        
    }
    
    public func hideDelayed(animated:NSNumber){
        self.hide(animated.boolValue)
    }
    
    public func handleGraceTimer(timer:NSTimer){
        if self.taskInProgress {
            self.setNeedsDisplay()
            self.showUsingAnimation(useAnimation)
        }
    }
    
    
    
    public func handleMinShowTimer(timer:NSTimer){
        
        dispatch_async(dispatch_get_main_queue(), {
            self.hideUsingAnimation(self.useAnimation)
        })
        
       
    }
    
    
   public  func showUsingAnimation(anim:Bool){
        self.alpha = 0.0
        if anim && animationType == RLHUDAnimation.ZoomIn {
            self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5, 0.5))
        }else if(anim  && animationType == RLHUDAnimation.ZoomOut){
            self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5, 1.5))
        }
        
        self.showStarted = NSDate()
        
        if anim {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.30)
            self.alpha = 1.0
            if animationType == RLHUDAnimation.ZoomIn || animationType == RLHUDAnimation.ZoomOut {
                self.transform = rotationTransform
            }
            
            UIView.commitAnimations()
            
        }else{
            self.alpha = 1.0
        }
        
        
        
    }
    
    public func hideUsingAnimation(anim:Bool){
        if anim  &&  showStarted != nil {
            UIView.animateWithDuration(0.30, animations: {
                if (self.animationType == RLHUDAnimation.ZoomIn) {
                    self.transform = CGAffineTransformConcat(self.rotationTransform, CGAffineTransformMakeScale(1.5, 1.5));
                } else if (self.animationType == RLHUDAnimation.ZoomOut) {
                    self.transform = CGAffineTransformConcat(self.rotationTransform, CGAffineTransformMakeScale(0.5, 0.5));
                }
                
                self.alpha = 0.02
                
                }, completion: { f  in
                    self.done()
            })
            
        }else {
            self.alpha = 0.0
            self.done()
        }
        self.showStarted = nil
    }
    
    
    public func done(){
        isFinished = true
        self.alpha = 0.0
        
        if self.completionBlock != nil {
            self.completionBlock!()
            self.completionBlock = nil
        }
        
        if removeFromSuperviewOnHide {
            self.removeFromSuperview()
        }
        
        
    }
    
    public func showWhileExecuting(method:Selector , onTarget target:AnyObject ,withObject obj:AnyObject , animated anim:Bool){
        methodForExecution = method
        targetForExecution = target
        objectForExecution = obj
        
        self.taskInProgress = true
        
        NSThread.detachNewThreadSelector(Selector("launchExecution"), toTarget: self, withObject: nil)
        
        self.show(anim)
    }
    
    public func launchExecution(){
        autoreleasepool({
            
            if self.targetForExecution != nil {
                
                NSThread.detachNewThreadSelector(self.methodForExecution!, toTarget: self.targetForExecution!, withObject: self.objectForExecution)
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.cleanUp()
                })
            }
            
        })
    }
   public func cleanUp(){
        taskInProgress = false
        
        self.hide(useAnimation)
    }
   public  func setupLabels(){
        self.label = UILabel(frame: self.bounds)
        label?.numberOfLines = 0
        label?.adjustsFontSizeToFitWidth = false
        label?.textAlignment = .Center
        label?.opaque = false
        label?.backgroundColor = UIColor.clearColor()
        label?.textColor = UIColor.whiteColor()
        label?.font = self.labelFont
        label?.text = self.labelText as String
        self.addSubview(label!)
        
        
        detailsLabel = UILabel(frame: self.bounds)
        detailsLabel?.font = self.detailsLabelFont
        detailsLabel?.adjustsFontSizeToFitWidth = false
        detailsLabel?.textAlignment = .Center
        detailsLabel?.opaque = false
        detailsLabel?.backgroundColor = UIColor.clearColor()
        detailsLabel?.textColor = UIColor.whiteColor()
        detailsLabel?.numberOfLines = 0
        detailsLabel?.font = self.detailsLabelFont
        detailsLabel?.text = self.detailsLabelText! as String
        self.addSubview(detailsLabel!)
        
        
    }
    
    
    public func updateIndicators(){
        
        var isActivityIndicator  = self.indicator is  UIActivityIndicatorView
        var isRoundIndicator =   self.indicator  is RLHUDRoundView
        
        if  mode == RLHUDMode.Determinate   &&  !isActivityIndicator{
            
            self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            let activityView =  self.indicator as! UIActivityIndicatorView
            activityView.startAnimating()
            
        }else if (mode == RLHUDMode.Determinate || mode == RLHUDMode.AnularDeterminate){
            
            if !isRoundIndicator {
                self.indicator = RLHUDRoundView()
            }
            if (mode == RLHUDMode.AnularDeterminate){
                (self.indicator as! RLHUDRoundView).annular = true
            }
        }else if (mode == RLHUDMode.CustomerView  &&  customView != indicator){
            
            self.indicator = customView
            
        }else if (mode == RLHUDMode.Text){
            self.indicator = nil
        }
        
        
        
    }
    override public func layoutSubviews() {
        
        var parent = self.superview
        if parent != nil {
            
            self.frame = parent!.bounds
        }
        
        var bounds = self.bounds
        var maxWidth:CGFloat = bounds.size.width - 4.0 * margin
        var totalSize = CGSizeZero
        var indicatorF = CGRectZero
        var labelSize:CGSize = CGSizeZero
        var detailsLabelSize = CGSizeZero
        
        
        if indicator != nil {
            indicatorF = indicator!.bounds
            indicatorF.size.width = min(indicatorF.size.width, maxWidth)
            totalSize.width = max(totalSize.width,indicatorF.size.width)
            totalSize.height += indicatorF.size.height
            
        }
        
        if label != nil  && label!.text != nil {
            
            var text = label!.text! as NSString
            labelSize = text.sizeWithAttributes([NSFontAttributeName: self.labelFont])
            totalSize.width = min(labelSize.width, maxWidth);
            totalSize.width = max(totalSize.width, labelSize.width);
            totalSize.height += labelSize.height;
            
            if (labelSize.height > 0.0 && indicatorF.size.height > 0.0) {
                totalSize.height += kPadding;
            }
            
        }
        
        
        var   remainingHeight:CGFloat = bounds.size.height - totalSize.height - kPadding - 4.0 * margin;
        
        var maxSize = CGSizeMake(maxWidth, remainingHeight)
        
        if detailsLabel != nil  && detailsLabel!.text != nil {
            var text = detailsLabel!.text!  as NSString
            
            var font = self.detailsLabelFont
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .ByWordWrapping;
            var attributes = [NSFontAttributeName:font,
                NSParagraphStyleAttributeName:paragraphStyle.copy()]
            
            var rect =  text.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes,context: nil)
            
            detailsLabelSize = rect.size
            
            totalSize.width = max(totalSize.width, detailsLabelSize.width);
            totalSize.height += detailsLabelSize.height;
            if (detailsLabelSize.height > 0.0 && (indicatorF.size.height > 0.0 || labelSize.height > 0.0)) {
                totalSize.height += kPadding;
            }
            
            totalSize.width += 2 * margin;
            totalSize.height += 2 * margin;
            
        }
        
        var yPos = round( (bounds.size.height - totalSize.height) / 2.0) + margin + yOffset
        var xPos = xOffset;
        
        indicatorF.origin.y = yPos
        indicatorF.origin.x = round(bounds.size.width - indicatorF.size.width / 2.0) + xPos
        indicator?.frame = indicatorF
        yPos += indicatorF.size.height
        
        if (labelSize.height > 0.0 && indicatorF.size.height > 0.0) {
            yPos += kPadding;
        }
        
        var detailsLabelF:CGRect = CGRectZero
        detailsLabelF.origin.y = yPos
        detailsLabelF.origin.x = round((bounds.size.width - detailsLabelSize.width) / 2.0) + xPos;
        detailsLabelF.size = detailsLabelSize
        
        detailsLabel?.frame = detailsLabelF
        
        if (square) {
            var aMax = max(totalSize.width, totalSize.height)
            if (aMax <= bounds.size.width - 2.0 * margin) {
                totalSize.width = aMax;
            }
            if (aMax <= bounds.size.height - 2.0 * margin) {
                totalSize.height = aMax;
            }
        }
        if (totalSize.width < minSize.width) {
            totalSize.width = minSize.width;
        }
        if (totalSize.height < minSize.height) {
            totalSize.height = minSize.height;
        }
        
        self.size = totalSize;
        
        
        
    }
    
    
     override public func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context)
        if self.dimBackground {
            var gradLocationsNum:size_t = 2
            var gradLocations:[CGFloat] = [0.0,1.0]
            var gradColors:[CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.75]
            var colorSpace = CGColorSpaceCreateDeviceRGB()
            var gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum)
            var gradCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
            var gradRadius = min(self.bounds.size.width , self.bounds.size.height)
            CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, 0)
        }
        if self.color != nil {
            CGContextSetFillColorWithColor(context, self.color!.CGColor);
        }else{
            CGContextSetGrayFillColor(context, 0.0, self.opacity);
        }
        var allRect = self.bounds
        var boxRect =  CGRectMake(round((allRect.size.width - size.width) / 2) + self.xOffset,
            round((allRect.size.height - size.height) / 2) + self.yOffset, size.width, size.height)
        
        var radius:CGFloat = 10.0
        CGContextBeginPath(context)
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
        CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 *  CGFloat(M_PI) / 2, 0, 0);
        CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0,  CGFloat(M_PI)  / 2, 0);
        CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius,  CGFloat(M_PI)  / 2,  CGFloat(M_PI) , 0);
        CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius,  CGFloat(M_PI) , 3 *  CGFloat(M_PI)  / 2, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
        UIGraphicsPopContext();
        
    }
    
    
    
    func setKeypath(keyPath:NSString){
        if  !NSThread.isMainThread() {
            dispatch_async(dispatch_get_main_queue(), {
                self.updateUIForKeypath(keyPath)
            });
        }else{
            self.updateUIForKeypath(keyPath)
        }
    }
    
    func updateUIForKeypath(keyPath:NSString){
        if keyPath.isEqualToString("mode") || (keyPath.isEqualToString("customView")) {
            self.updateIndicators()
        }else if keyPath.isEqualToString("labelText") {
            label?.text = self.labelText as String;
        } else if (keyPath.isEqualToString ("labelFont")) {
            label?.font = self.labelFont;
        } else if (keyPath.isEqualToString("detailsLabelText")) {
            detailsLabel?.text = self.detailsLabelText as? String;
        } else if (keyPath.isEqualToString("detailsLabelFont")) {
            detailsLabel?.font = self.detailsLabelFont;
        } else if (keyPath.isEqualToString("progress")) {
            if (self.indicator?.respondsToSelector(Selector("setProgress:")) != nil) {
                NSThread.detachNewThreadSelector(Selector("setProgress:"), toTarget: self, withObject: nil)
            }
            return;
        }
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    func observableKeypaths()->NSArray{
        return NSArray(arrayLiteral: "mode","customView","labelText","labelFont","detailsLabelText","detailsLabelFont","progress")
    }
    
    func registerForNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("deviceOrientationDidChange:"), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    }
    
    func unregisterFromNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func deviceOrientationDidChange(notification:NSNotification){
        var superview = self.superview
        if superview != nil {
            if superview! is UIWindow {
                self.setTransformForCurrentOrientation(true)
            }else {
                self.bounds = self.superview!.bounds
                self.setNeedsDisplay()
            }
            
        }else{
            return;
        }
    }
    
    func setTransformForCurrentOrientation(aBool:Bool){
        if self.superview != nil {
            self.bounds = self.superview!.bounds
            self.setNeedsDisplay()
            
        }
        
    }
    
    
    
    
    
    
    
}

public class RLHUDRoundView:UIView{
    
    private var _progress:CGFloat = 0.0
    internal var progress:CGFloat {
        get{
            return _progress
        }
        set{
            _progress = newValue
            self.setNeedsDisplay()
        }
    }
    
//    internal func setProgress(aValue:CGFloat){
//        self.progress = aValue
//    }
    
    private var _annular:Bool = false
    
    internal var annular:Bool{
        get{
            return _annular
        }
        set{
            _annular = newValue
            self.setNeedsDisplay()
        }
        
    }
    
    convenience   init(){
        
        self.init(frame: CGRectMake(0.0, 0.0, 37.0, 37.0))
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false
        
        
    }
    
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func drawRect(rect: CGRect) {
        
        var allRect = self.bounds
        var circleRect = CGRectInset(allRect, 2.0, 2.0);
        var context = UIGraphicsGetCurrentContext()
        if self.annular {
            var lineWidth:CGFloat = 5.0
            var processBackgroundPath = UIBezierPath()
            processBackgroundPath.lineWidth = lineWidth
            processBackgroundPath.lineCapStyle = kCGLineCapRound
            var center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
            var radius = (self.bounds.size.width - lineWidth)/2
            var startAngle = -(CGFloat(M_PI) / 2)
            var endAngle = (2 * CGFloat(M_PI)) + startAngle
            processBackgroundPath.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).set()
            processBackgroundPath.stroke()
            
            
            var processPath = UIBezierPath()
            processPath.lineCapStyle = kCGLineCapRound
            processPath.lineWidth = lineWidth
            
            endAngle = (self.progress * 2 *  CGFloat(M_PI)) + startAngle
            processPath.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            UIColor.whiteColor().set()
            processPath.stroke()
            
        }else{
            CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0) // white
            CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.1) // translucent white
            CGContextSetLineWidth(context, 2.0);
            CGContextFillEllipseInRect(context, circleRect)
            CGContextStrokeEllipseInRect(context, circleRect)
            
            
            var center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2)
            var radius = (allRect.size.width - 4) / 2
            var startAngle = -(CGFloat(M_PI) / 2)
            var endAngle = (self.progress * 2 * CGFloat(M_PI)) + startAngle
            
            CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0) // white
            CGContextMoveToPoint(context, center.x, center.y)
            CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0)
            CGContextClosePath(context)
            CGContextFillPath(context)
            
        }
        
    }
    
}



