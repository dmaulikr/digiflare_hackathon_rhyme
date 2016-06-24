//
//  ViewController.swift
//  RhymeGame
//
//  Created by Sergii Gavryliuk on 2016-06-24.
//  Copyright © 2016 Sergey Gavrilyuk. All rights reserved.
//

import UIKit
import SpeechKit

class ViewController: UIViewController {
    
    let tableView: UITableView = UITableView.init()
    let recordButton: UIButton = UIButton(type: .Custom)
    
    let recordingImageView: UIImageView = UIImageView(image: UIImage.init(named: ""))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        let manager:SpeechKitManager = SpeechKitManager.sharedInstance
        manager.recordSpeech(SKTransactionSpeechTypeDictation, detection: .Short)
        
        
        let baseAPIClient: BaseAPIClient = BaseAPIClient.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        baseAPIClient.genericTaskWithRequest("https://digiflare-hackathon-rhyme-game.herokuapp.com/rhyme", method: .POST, arguementsDictionary: nil, paramsDictionary: ["payload": "test"], customHeaderDictionary: ["Content-Type": "application/json"]) { (response:AnyObject?, nsURLResponse:NSURLResponse?, error:NSError?) in

            if let e = error {
                let alertController:UIAlertController = UIAlertController(title: "Error", message: e.description, preferredStyle: .Alert);
                self.navigationController?.pushViewController(alertController, animated: true);
            }
            
            guard let dic = response as? [String:AnyObject] else {
                return
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

