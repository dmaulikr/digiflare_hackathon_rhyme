//
//  RhymeHerokuClient.swift
//  RhymeGame
//
//  Created by Kevin Kruusi on 2016-06-24.
//  Copyright © 2016 Sergey Gavrilyuk. All rights reserved.
//

import Foundation

typealias HerokuCompletionHandler = ([String:AnyObject]?, NSURLResponse?, NSError?)->Void

class HerokuClient : BaseAPIClient {
    
    let baseURL = "https://digiflare-hackathon-rhyme-game.herokuapp.com"
    
    init(){
        super.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    func fetchRhyme(phrase:String, completion: HerokuCompletionHandler) {
        let fullPath = "\(baseURL)/rhyme"
        
        self.genericTaskWithRequest(fullPath, method: .POST, arguementsDictionary: nil, paramsDictionary: ["payload": phrase], customHeaderDictionary: ["Content-Type": "application/json"]) { (response:AnyObject?, nsURLResponse:NSURLResponse?, error:NSError?) in
            
            guard let dic = response as? [String:AnyObject] else {
                return
            }
            completion(dic, nsURLResponse, error)
            
        }
    }

}

//
//
//        let baseAPIClient: BaseAPIClient = BaseAPIClient.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
//
//        baseAPIClient.genericTaskWithRequest("https://digiflare-hackathon-rhyme-game.herokuapp.com/rhyme", method: .POST, arguementsDictionary: nil, paramsDictionary: ["payload": "test"], customHeaderDictionary: ["Content-Type": "application/json"]) { (response:AnyObject?, nsURLResponse:NSURLResponse?, error:NSError?) in
//
//            if let e = error {
//                let alertController:UIAlertController = UIAlertController(title: "Error", message: e.description, preferredStyle: .Alert);
//                self.navigationController?.pushViewController(alertController, animated: true);
//            }
//
//            guard let dic = response as? [String:AnyObject] else {
//                return
//            }
//        }