//
//  BaseAPIClient.swift
//  appletv
//
//  Created by Kevin Kruusi on 2016-01-25.
//  Copyright © 2016 Rogers. All rights reserved.
//

import Foundation
import UIKit


enum BaseAPIClient_HTTPMethod:String{
    case GET
    case POST
}

typealias JsonTaskCompletionHandler = (AnyObject?, NSURLResponse?, NSError?)->Void

class BaseAPIClient{
    
    let kBaseAPIClient_ErrorDomain = "BaseAPIClientError"
    
    let configuration: NSURLSessionConfiguration
    
    lazy var session: NSURLSession = {
        return NSURLSession.sharedSession()
    }()
    
    init(configuration: NSURLSessionConfiguration){
        self.configuration = configuration;
    }
    
    func genericTaskWithRequest(fullPath:String, method:BaseAPIClient_HTTPMethod, arguementsDictionary:NSDictionary?, paramsDictionary:NSDictionary?,customHeaderDictionary:NSDictionary?, completion:JsonTaskCompletionHandler){
        //setup request
        var path:String                 = fullPath
        
        var symbol = "?"
        if let args = arguementsDictionary{
            for (key, value) in args{
                path += "\(symbol)\(key)=\(value)"
                symbol = "&"
            }
        }
        NSLog("REBaseAPIClient Request->\(path)")
        let url:NSURL                   = NSURL.init(string: path)!
        let request:NSMutableURLRequest = NSMutableURLRequest.init(URL: url)
        request.HTTPMethod              = method.rawValue
        
        //add header
        if let headerDic = customHeaderDictionary{
            for (key,value) in headerDic{
                request.addValue(value as! String, forHTTPHeaderField: key as! String)
            }
        }
        
        //add body
        if let paramDic = paramsDictionary{
            do{
                let bodyData = try NSJSONSerialization.dataWithJSONObject(paramDic, options: [])
                request.HTTPBody = bodyData
            }catch{
                completion(nil, nil, NSError(domain: kBaseAPIClient_ErrorDomain, code: 8, userInfo: ["message":"failed to create body data"]))
            }
        }
        //make task
        var task:NSURLSessionDataTask;
        task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            run_on_background({ () -> Void in
                
                
                guard let http = response as? NSHTTPURLResponse else{
                    run_on_main({ () -> Void in
                        completion(nil, nil, NSError(domain:self.kBaseAPIClient_ErrorDomain, code:9, userInfo: ["message":"cannot connect to \(fullPath)"]))
                        
                    })
                    return
                }
                
                if let e = error{
                    run_on_main({ () -> Void in
                        completion(nil, http, e)
                    })
                }else{
                    if let _data = data{
                        do{
                            
                            let json = try NSJSONSerialization.JSONObjectWithData(_data, options: .MutableContainers)
                            run_on_main({ () -> Void in
                                completion(json, http, nil)
                            })
                        }catch{
                            
                            if(http.statusCode == 200){
                                
                                if let headers:NSDictionary = http.allHeaderFields{
                                    //handle non json data
                                    if let content:String = headers.objectForKey("Content-Type") as? String{
                                        if content == "image/jpeg" || content == "image/jpg" || content == "image/png"{
                                            
                                            if let image:UIImage = UIImage(data: _data){
                                                run_on_main({ () -> Void in
                                                    completion(image, http, nil)
                                                })
                                                return
                                            }else{
                                                NSLog("Error creating UIImage from NSData")
                                            }
                                        }
                                    }
                                }
                                run_on_main({ () -> Void in
                                    completion(_data, http, nil)
                                })
                                return
                            }else if(http.statusCode == 404){
                                run_on_main({ () -> Void in
                                    completion(nil, http, NSError(domain:self.kBaseAPIClient_ErrorDomain, code:404, userInfo:["message":"endpoint not found: \(path)", "data": _data]))
                                })
                                return
                            }
                            
                            run_on_main({ () -> Void in
                                completion(nil, http, NSError(domain:self.kBaseAPIClient_ErrorDomain, code:10, userInfo:["message":"cannot translate returned data", "data": _data]))
                            })
                            
                        }
                    }else{
                        run_on_main({ () -> Void in
                            completion(nil, http, NSError(domain:self.kBaseAPIClient_ErrorDomain, code:11, userInfo:["message":"emptyresponse from server \(fullPath)"]))
                        })
                    }
                }
            })
            
        })
        
        run_on_background { () -> Void in
            task.resume()
        }
    }
}