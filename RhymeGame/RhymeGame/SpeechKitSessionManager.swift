//
//  SpeechKitSessionManager.swift
//  RhymeGame
//
//  Created by Kevin Kruusi on 2016-06-24.
//  Copyright © 2016 Sergey Gavrilyuk. All rights reserved.
//

import Foundation
import SpeechKit

class SpeechKitSessionManager: NSObject, SKTransactionDelegate{
    
    private let session:SKSession
    private let sKSAppKey:String = "b3d613f5764bf44ce62c08b0105c2a671560b9ddb48a265205d77d31142e63c70476bc7ac2b0c6a8ddce58ed2a825540e30e1d979944e99e1b66cf2f9432f698"
    private let serverURL:String = "nmsps://NMDPTRIAL_sergey_gavrilyuk_gmail_com20160624105026@sslsandbox.nmdp.nuancemobility.net:443"
    
    static let sharedInstance = SpeechKitSessionManager();

    private override init() {
        
        let url:NSURL = NSURL(string: serverURL)!
        
        session = SKSession(URL: url, appToken: sKSAppKey)
    }
    
    func transactionDidBeginRecording(transaction: SKTransaction!) {
        print("Speech Kit transaction Did Begin Recording");
    }
    
    func transactionDidFinishRecording(transaction: SKTransaction!) {
        print("Speech Kit transaction Did Finish Recording")
    }
    
    func transaction(transaction: SKTransaction!, didReceiveRecognition recognition: SKRecognition!) {
        print("Speech Kit transaction receives a text recognition")
    }
    
    func transaction(transaction: SKTransaction!, didReceiveInterpretation interpretation: SKInterpretation!) {
        print("Speech Kit did Receive Interpretation")
    }
    
    func transaction(transaction: SKTransaction!, didReceiveServiceResponse response: [NSObject : AnyObject]!) {
        print("Speech Kit did Receive Response")
    }
    
    func transaction(transaction: SKTransaction!, didReceiveAudio audio: SKAudio!) {
        print("Speech Kit did Receive Audio")
    }
    
    func transaction(transaction: SKTransaction!, didFinishWithSuggestion suggestion: String!) {
        print("Speech Kit did Finish with Suggestion")
    }
    
    func transaction(transaction: SKTransaction!, didFailWithError error: NSError!, suggestion: String!) {
        let message = String.localizedStringWithFormat("Speech Kit did Fail with Error @%", error.userInfo["NSLocalizedDescription"] as! String)
        print(message)
    }
    
    func recordSpeech(type: String, detection:SKTransactionEndOfSpeechDetection) {
        let _ = session.recognizeWithType(type,
                                detection: detection,
                                language: "eng-USA",
                                delegate: self)
    }
}
