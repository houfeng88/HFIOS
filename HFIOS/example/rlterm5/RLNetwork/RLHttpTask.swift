//
//  RLHttpTask.swift
//  rlterm3
//
//  Created by houfeng on 3/16/15.
//  Copyright (c) 2015 RepeatLink. All rights reserved.
//
import Foundation
#if os(iOS)
    import MobileCoreServices
#endif
extension String{
    
//对url字符串进行特殊处理 如果字符串含有 /?&=;+!@#$() 等，用“%+ASCII” 代替
//    var escaped:String{
//        return  CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,self,"[].",":/?&=;+!@#$()',*",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
//    }
    var escaped:String{
       return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!;
    }
}

public enum RLHTTPMethod:String{
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
}

public class RLHTTPUpload:NSObject{
    var fileURL:NSURL?{
        didSet {
            updateMimeType()
            loadData()
        }
    }
    
    var mimeType:String?
    var data:NSData?
    var fileName:String?
    
    func updateMimeType(){
        if mimeType == nil && fileURL != nil {
            var UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileURL?.pathExtension as NSString?, nil);
            var str = UTTypeCopyPreferredTagWithClass(UTI.takeUnretainedValue(), kUTTagClassMIMEType);
            if (str == nil) {
                mimeType = "application/octet-stream";
            } else {
                mimeType = str.takeUnretainedValue()  as String
            }
            
        }
    }
    
    func loadData(){
        if let url = fileURL {
            self.fileName = url.lastPathComponent
            self.data = NSData.dataWithContentsOfMappedFile(url.path!) as? NSData
        }
    }
    public override init() {
        super.init()
    }
    public convenience init(fileUrl: NSURL) {
        self.init()
        self.fileURL = fileUrl
        updateMimeType()
        loadData()
    }
    
    public convenience init(data: NSData, fileName: String, mimeType: String) {
        self.init()
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
    
}
class RLHTTPPair:NSObject{
    var value: AnyObject
    var key: String!
    init(value: AnyObject, key: String?) {
        self.value = value
        self.key = key
    }
    func getUpload() -> RLHTTPUpload? {
        return self.value as? RLHTTPUpload
    }
    
    func getValue() -> String {
        var val = ""
        if let str = self.value as? String {
            val = str
        } else if self.value.description != nil {
            val = self.value.description
        }
        return val
    }
    
    func stringValue() -> String {
        var val = getValue()
        if self.key == nil {
            return val.escaped
        }
        return "\(self.key.escaped)=\(val.escaped)"
    }
    
}

public class RLHTTPRequestSerializer:NSObject{
    let contentTypeKey = "Content-Type"
    public var headers = Dictionary<String,String>()
    public var stringEncoding:UInt = NSUTF8StringEncoding
    public var allowsCellularAccess = true
    public var HTTPShouldHandleCookies = true
    public var HTTPShouldUsePipelining = false
    public var timeoutInterval:NSTimeInterval  = 60
    public var cachePolicy:NSURLRequestCachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
    public var networkServiceType = NSURLRequestNetworkServiceType.NetworkServiceTypeDefault
    
    
    func newRequest(url:NSURL,method:RLHTTPMethod) -> NSMutableURLRequest{
        var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.HTTPMethod = method.rawValue
        request.cachePolicy = self.cachePolicy
        request.allowsCellularAccess = self.allowsCellularAccess
        request.HTTPShouldHandleCookies = self.HTTPShouldHandleCookies
        request.HTTPShouldUsePipelining  = self.HTTPShouldUsePipelining
        request.networkServiceType = self.networkServiceType
        for (key,val) in self.headers{
            request.addValue(val, forHTTPHeaderField: key)
        }
        return request
    }
    
    func isMultiForm(params: Dictionary<String,AnyObject>) -> Bool {
        for (name,object:AnyObject) in params {
            if object is RLHTTPUpload {
                return true
            }else if let subParams = object as? Dictionary<String,AnyObject> {
                if isMultiForm(subParams) {
                    return true
                }
            }
        }
        return false
    }
    
    func serializeObject(object: AnyObject,key: String?) -> Array<RLHTTPPair>{
        var collect = Array<RLHTTPPair>()
        if let array = object as? Array<AnyObject>  {
            for nestedValue:AnyObject in array {
                collect.extend(self.serializeObject(nestedValue,key: "\(key!)[]"))
            }
        }else if let dict = object as? Dictionary<String,AnyObject> {
            for (nestedKey, nestedObject: AnyObject) in dict {
                var newKey = key != nil ? "\(key!)[\(nestedKey)]" : nestedKey
                collect.extend(self.serializeObject(nestedObject,key: newKey))
            }
        } else {
            collect.append(RLHTTPPair(value: object, key: key))
        }
        
        return collect
    }
    func multiFormHeader(name: String, fileName: String?, type: String?, multiCRLF: String) -> String{
        
        var str = "Content-Disposition: form-data; name=\"\(name.escaped)\""
        if fileName != nil {
            str += "; filename=\"\(fileName!)\""
        }
        str += multiCRLF
        if type != nil {
            str += "Content-Type: \(type!)\(multiCRLF)"
        }
        str += multiCRLF
        return str
    }
    
    
    func dataFromParameters(parameters: Dictionary<String,AnyObject>,boundary: String) -> NSData{
        var mutData = NSMutableData()
        var multiCRLF = "\r\n"
        var boundSplit =  "\(multiCRLF)--\(boundary)\(multiCRLF)".dataUsingEncoding(self.stringEncoding)!
        var lastBound =  "\(multiCRLF)--\(boundary)--\(multiCRLF)".dataUsingEncoding(self.stringEncoding)!
        mutData.appendData("--\(boundary)\(multiCRLF)".dataUsingEncoding(self.stringEncoding)!)
        
        let pairs = serializeObject(parameters, key: nil)
        let count = pairs.count - 1
        var i = 0
        for pair in pairs {
            var append = true
            if let upload = pair.getUpload() {
                if let data = upload.data {
                    mutData.appendData(multiFormHeader(pair.key, fileName: upload.fileName,
                        type: upload.mimeType, multiCRLF: multiCRLF).dataUsingEncoding(self.stringEncoding)!)
                    mutData.appendData(data)
                }else{
                    append = false
                }
            }else{
                let str = "\(self.multiFormHeader(pair.key, fileName: nil, type: nil, multiCRLF: multiCRLF))\(pair.getValue())"
                mutData.appendData(str.dataUsingEncoding(self.stringEncoding)!)
            }
            
            if append {
                if i == count {
                    mutData.appendData(lastBound)
                } else {
                    mutData.appendData(boundSplit)
                }
            }
            
            i++
        }
        
        return mutData
        
    }
    
    
    
    func stringFromParameters(parameters: Dictionary<String,AnyObject>) -> String {
        return join("&", map(serializeObject(parameters, key: nil), {(pair) in
            return pair.stringValue()
        }))
    }
    
    
    func isURIParam(method: RLHTTPMethod) -> Bool {
        //        if( RLHTTPMethod.GET == method  ||  RLHTTPMethod.HEAD == method  || RLHTTPMethod.DELETE == method  ) {
        //            return true
        //        }
        //        return false
        
        if( RLHTTPMethod.GET.rawValue == method.rawValue  ||  RLHTTPMethod.HEAD.rawValue == method.rawValue  || RLHTTPMethod.DELETE.rawValue == method.rawValue  ) {
            return true
        }
        return false
        
        
        //        return true
    }
    
    
    //
    func createRequest(url:NSURL,method:RLHTTPMethod,parameters: Dictionary<String,AnyObject>?) -> (request: NSURLRequest, error: NSError?){
        
        var request = newRequest(url, method: method)
        var isMulti = false
        if let params = parameters {
            isMulti = isMultiForm(params)
        }
        if isMulti {
            if(method != .POST && method != .PUT) {
                request.HTTPMethod = RLHTTPMethod.POST.rawValue
            }
            var boundary = "Boundary+\(arc4random())\(arc4random())"
            if parameters != nil {
                request.HTTPBody = dataFromParameters(parameters!,boundary: boundary)
                println( NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding))
                
            }
            if request.valueForHTTPHeaderField(contentTypeKey) == nil {
                request.setValue("multipart/form-data; boundary=\(boundary)",
                    forHTTPHeaderField:contentTypeKey)
            }
            return (request,nil)
            
        }
        
        
        var queryString = ""
        if parameters != nil {
            queryString = self.stringFromParameters(parameters!)
        }
        
        if isURIParam(method) {
            var para = (request.URL!.query != nil) ? "&" : "?"
            var newUrl = "\(request.URL!.absoluteString!)"
            if count(queryString) > 0 {
                newUrl += "\(para)\(queryString)"
            }
            request.URL = NSURL(string: newUrl)
        } else {
            var charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
            if request.valueForHTTPHeaderField(contentTypeKey) == nil {
                request.setValue("application/x-www-form-urlencoded; charset=\(charset)",
                    forHTTPHeaderField:contentTypeKey)
            }
            request.HTTPBody = queryString.dataUsingEncoding(self.stringEncoding)
        }
        
        
        return (request,nil)
        
    }
    
    
    
}


public class RLJSONRequestSerializer:RLHTTPRequestSerializer{
    public override func createRequest(url: NSURL, method: RLHTTPMethod, parameters: Dictionary<String,AnyObject>?) -> (request: NSURLRequest, error: NSError?) {
        if self.isURIParam(method) {
            return super.createRequest(url, method: method, parameters: parameters)
        }
        var request = newRequest(url, method: method)
        var error: NSError?
        if parameters != nil {
            var charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            request.setValue("application/json; charset=\(charset)", forHTTPHeaderField: self.contentTypeKey)
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters!, options: NSJSONWritingOptions(), error:&error)
        }
        return (request, error)
    }
    
}


public protocol RLHTTPResponseSerializer {
    func responseObjectFromResponse(response: NSURLResponse, data: NSData) -> (object: AnyObject?, error: NSError?)
}

public struct RLJSONResponseSerializer : RLHTTPResponseSerializer {
    public init(){}
    
    public func responseObjectFromResponse(response: NSURLResponse, data: NSData) -> (object: AnyObject?, error: NSError?) {
        var error: NSError?
        let response: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error)
        return (response,error)
    }
}


public class RLHTTPResponse {
    public var headers: Dictionary<String,String>?
    public var mimeType: String?
    public var suggestedFilename: String?
    public var responseObject: AnyObject?
    public var statusCode: Int?
    public func text() -> NSString? {
        if let d = self.responseObject as? NSData {
            return  NSString(data: d, encoding: NSUTF8StringEncoding)
        }
        return nil
    }
    public var URL: NSURL?
}
public struct RLHTTPAuth {
    public var username: String
    public var password: String
    public var persistence: NSURLCredentialPersistence
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
        self.persistence = .ForSession
    }
}
class RLBackgroundBlocks {
    var success:((RLHTTPResponse) -> Void)?
    var failure:((NSError, RLHTTPResponse?) -> Void)?
    var progress:((Double) -> Void)?
    
    init(_ success: ((RLHTTPResponse) -> Void)?, _ failure: ((NSError, RLHTTPResponse?) -> Void)?,_ progress: ((Double) -> Void)?) {
        self.failure = failure
        self.success = success
        self.progress = progress
    }
}

public class RLHTTPOperation : NSOperation {
    private var task: NSURLSessionDataTask!
    private var stopped = false
    private var running = false
    
    public var done = false
    
    
    override public var asynchronous: Bool {
        return false
    }
    
    override public var cancelled: Bool {
        return stopped
    }
    
    override public var executing: Bool {
        return running
    }
    
    override public var finished: Bool {
        return done
    }
    
    override public var ready: Bool {
        return !running
    }
    
    override public func start() {
        super.start()
        stopped = false
        running = true
        done = false
        task.resume()
    }
    
    override public func cancel() {
        super.cancel()
        running = false
        stopped = true
        done = true
        task.cancel()
    }
    
    public func finish() {
        self.willChangeValueForKey("isExecuting")
        self.willChangeValueForKey("isFinished")
        
        running = false
        done = true
        
        self.didChangeValueForKey("isExecuting")
        self.didChangeValueForKey("isFinished")
    }
}


public class RLHttpTask: NSObject , NSURLSessionDelegate, NSURLSessionTaskDelegate{
    var backgroundTaskMap = Dictionary<String,RLBackgroundBlocks>()
    internal var baseURL: String?
    internal var requestSerializer = RLHTTPRequestSerializer()
    internal var responseSerializer: RLHTTPResponseSerializer?
    internal var auth: RLHTTPAuth?
    
    public override init() {
        super.init()
    }
    
    private func createRequest(url: String, method: RLHTTPMethod, parameters: Dictionary<String,AnyObject>!) -> (request: NSURLRequest, error: NSError?) {
        var urlVal = url
        if (!url.hasPrefix("http") || !url.hasPrefix("https")) && self.baseURL != nil {
            var split = url.hasPrefix("/") ? "" : "/"
            urlVal = "\(self.baseURL!)\(split)\(url)"
        }
        return self.requestSerializer.createRequest(NSURL(string: urlVal)!, method: method, parameters: parameters)
    }
    
    private func createError(code: Int) -> NSError {
        var text = "An error occured"
        if code == 404 {
            text = "page not found"
        } else if code == 401 {
            text = "accessed denied"
        }
        return NSError(domain: "HTTPTask", code: code, userInfo: [NSLocalizedDescriptionKey: text])
    }
    
    private func create(url: String, method: RLHTTPMethod, parameters: Dictionary<String,AnyObject>!, success:((RLHTTPResponse) -> Void)!, failure:((NSError, RLHTTPResponse?) -> Void)!) ->  RLHTTPOperation?{
        let serialReq = createRequest(url, method: method, parameters: parameters)
        if serialReq.error != nil {
            if failure != nil {
                failure(serialReq.error!, nil)
            }
            return nil
        }
        
        let opt = RLHTTPOperation()
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.dataTaskWithRequest(serialReq.request,
            completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                opt.finish()
                if error != nil {
                    if failure != nil {
                        failure(error, nil)
                    }
                    return
                }
                if data != nil {
                    var responseObject: AnyObject = data
                    if self.responseSerializer != nil {
                        let resObj = self.responseSerializer!.responseObjectFromResponse(response, data: data)
                        if resObj.error != nil {
                            if failure != nil {
                                failure(resObj.error!, nil)
                            }
                            return
                        }
                        if resObj.object != nil {
                            responseObject = resObj.object!
                        }
                    }
                    var extraResponse = RLHTTPResponse()
                    if let hresponse = response as? NSHTTPURLResponse {
                        extraResponse.headers = hresponse.allHeaderFields as? Dictionary<String,String>
                        extraResponse.mimeType = hresponse.MIMEType
                        extraResponse.suggestedFilename = hresponse.suggestedFilename
                        extraResponse.statusCode = hresponse.statusCode
                        extraResponse.URL = hresponse.URL
                    }
                    extraResponse.responseObject = responseObject
                    if extraResponse.statusCode > 299 {
                        if failure != nil {
                            failure(self.createError(extraResponse.statusCode!), extraResponse)
                        }
                    } else if success != nil {
                        success(extraResponse)
                    }
                } else if failure != nil {
                    failure(error, nil)
                }
        })
        opt.task = task
        return opt
        
    }
    
    public func GET(url: String, parameters: Dictionary<String,AnyObject>?, success:((RLHTTPResponse) -> Void)!, failure:((NSError, RLHTTPResponse?) -> Void)!) {
        var opt = self.create(url, method:.GET, parameters: parameters,success: success,failure: failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    public func POST(url: String, parameters: Dictionary<String,AnyObject>?, success:((RLHTTPResponse) -> Void)!, failure:((NSError, RLHTTPResponse?) -> Void)!) {
        var opt = self.create(url, method:.POST, parameters: parameters,success: success,failure: failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    
    public func PUT(url: String, parameters: Dictionary<String,AnyObject>?, success:((RLHTTPResponse) -> Void)!, failure:((NSError, RLHTTPResponse?) -> Void)!) {
        var opt = self.create(url, method:.PUT, parameters: parameters,success: success,failure: failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    internal func DELETE(url: String, parameters: Dictionary<String,AnyObject>?, success:((RLHTTPResponse) -> Void)!, failure:((NSError, RLHTTPResponse?) -> Void)!)  {
        var opt = self.create(url, method:.DELETE, parameters: parameters,success: success,failure: failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    public func HEAD(url: String, parameters: Dictionary<String,AnyObject>?, success:((RLHTTPResponse) -> Void)!, failure:((NSError, RLHTTPResponse?) -> Void)!) {
        var opt = self.create(url, method:.HEAD, parameters: parameters,success: success,failure: failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    
    public func download(url: String, parameters: Dictionary<String,AnyObject>?,progress:((Double) -> Void)!, success:((RLHTTPResponse) -> Void)!, failure:((NSError, RLHTTPResponse?) -> Void)!) -> NSURLSessionDownloadTask? {
        let serialReq = createRequest(url,method: .GET, parameters: parameters)
        if serialReq.error != nil {
            failure(serialReq.error!, nil)
            return nil
        }
        let ident = createBackgroundIdent()
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(ident)
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithRequest(serialReq.request)
        self.backgroundTaskMap[ident] = RLBackgroundBlocks(success,failure,progress)
        //this does not have to be queueable as Apple's background dameon *should* handle that.
        task.resume()
        return task
    }
    
    public func uploadFile(url: String, parameters: Dictionary<String,AnyObject>?, progress:((Double) -> Void)!, success:((RLHTTPResponse) -> Void)!, failure:((NSError) -> Void)!) -> Void {
        let serialReq = createRequest(url,method: .GET, parameters: parameters)
        if serialReq.error != nil {
            failure(serialReq.error!)
            return
        }
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(createBackgroundIdent())
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        //session.uploadTaskWithRequest(serialReq.request, fromData: nil)
    }
    
    
    
    private func createBackgroundIdent() -> String {
        let letters = "abcdefghijklmnopqurstuvwxyz"
        var str = ""
        for var i = 0; i < 14; i++ {
            let start = Int(arc4random() % 14)
            str.append(letters[advance(letters.startIndex,start)])
        }
        return "com.vluxe.rlhttptask.request.\(str)"
    }
    
    private func cleanupBackground(identifier: String) {
        self.backgroundTaskMap.removeValueForKey(identifier)
    }
    
    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        if let a = auth {
            let cred = NSURLCredential(user: a.username, password: a.password, persistence: a.persistence)
            completionHandler(.UseCredential, cred)
            return
        }
        
        let cred = NSURLCredential(trust: challenge.protectionSpace.serverTrust)
        completionHandler(.UseCredential, cred)
    }
    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            let blocks = self.backgroundTaskMap[session.configuration.identifier]
            if blocks?.failure != nil {
                blocks?.failure!(error!, nil)
                cleanupBackground(session.configuration.identifier)
            }
        }
    }
    
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didFinishDownloadingToURL location: NSURL!) {
        let blocks = self.backgroundTaskMap[session.configuration.identifier]
        if blocks?.success != nil {
            var resp = RLHTTPResponse()
            if let hresponse = downloadTask.response as? NSHTTPURLResponse {
                resp.headers = hresponse.allHeaderFields as? Dictionary<String,String>
                resp.mimeType = hresponse.MIMEType
                resp.suggestedFilename = hresponse.suggestedFilename
                resp.statusCode = hresponse.statusCode
                resp.URL = hresponse.URL
            }
            resp.responseObject = location
            if resp.statusCode > 299 {
                if blocks?.failure != nil {
                    blocks?.failure!(self.createError(resp.statusCode!), resp)
                }
                return
            }
            blocks?.success!(resp)
            cleanupBackground(session.configuration.identifier)
        }
    }
    
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let increment = 100.0/Double(totalBytesExpectedToWrite)
        var current = (increment*Double(totalBytesWritten))*0.01
        if current > 1 {
            current = 1;
        }
        let blocks = self.backgroundTaskMap[session.configuration.identifier]
        if blocks?.progress != nil {
            blocks?.progress!(current)
        }
    }
    public func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
    }
    
    
    func URLSession(session: NSURLSession!, dataTask: NSURLSessionDataTask!, didReceiveData data: NSData!) {
    }
    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    }
    
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    
}
