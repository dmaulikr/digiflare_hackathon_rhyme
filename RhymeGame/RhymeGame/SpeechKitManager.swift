//
//  SpeechKitSessionManager.swift
//  RhymeGame
//
//  Created by Kevin Kruusi on 2016-06-24.
//  Copyright © 2016 Sergey Gavrilyuk. All rights reserved.
//

import Foundation
import SpeechKit
import UIKit

enum SpeechKitManagerState {
    case Unknown
    case Ready
    case Recording
    case Waiting
}

protocol SpeechKitManagerUpdateProtocol {
    
    func speechKitManagerStateDidChange(state: SpeechKitManagerState, info: SKTransaction?)
    
    func speechKitManagerUpdateChat(chat:String, isYou:Bool, points:Int)
}

class SpeechKitManager: NSObject, SKTransactionDelegate{
    
    private let session:SKSession
    private let sKSAppKey:String = "b3d613f5764bf44ce62c08b0105c2a671560b9ddb48a265205d77d31142e63c70476bc7ac2b0c6a8ddce58ed2a825540e30e1d979944e99e1b66cf2f9432f698"
    private let serverURL:String = "nmsps://NMDPTRIAL_sergey_gavrilyuk_gmail_com20160624105026@sslsandbox.nmdp.nuancemobility.net:443"
    
    let herokuClient:HerokuClient = HerokuClient()
    
    var state: SpeechKitManagerState = .Unknown
    var delegate: SpeechKitManagerUpdateProtocol?
    
    override init() {
        let url:NSURL = NSURL(string: serverURL)!
        session = SKSession(URL: url, appToken: sKSAppKey)
        super.init()
    }
    
    func transactionDidBeginRecording(transaction: SKTransaction!) {
        print("Speech Kit transaction Did Begin Recording");
        state = .Recording
        delegate?.speechKitManagerStateDidChange(state, info: transaction)
    }
    
    func transactionDidFinishRecording(transaction: SKTransaction!) {
        print("Speech Kit transaction Did Finish Recording")
        state = .Ready
        delegate?.speechKitManagerStateDidChange(state, info: transaction)
    }
    
    func transaction(transaction: SKTransaction!, didReceiveRecognition recognition: SKRecognition!) {
        print("Speech Kit transaction receives a text recognition")
        
        //Take the best result
        let topRecognitionText = recognition.text;
      
  
        
        herokuClient.fetchRhyme(topRecognitionText) { (data:[String : AnyObject]?, nsURLResponse:NSURLResponse?, error:NSError?) in
            
            //get make a tile for your rhym
            self.delegate?.speechKitManagerUpdateChat(topRecognitionText, isYou:true, points: 100)
            
            guard let d = data, rhyme = d["response"] as? String else{
                return
            }
            //make a tile for the computers rhyme
            self.delegate?.speechKitManagerUpdateChat(rhyme, isYou: false, points: 100)
        }
    }
    
    func transaction(transaction: SKTransaction!, didReceiveInterpretation interpretation: SKInterpretation!) {
        print("Speech Kit did Receive Interpretation")
    }
    
    func transaction(transaction: SKTransaction!, didReceiveServiceResponse response: [NSObject : AnyObject]!) {
        print("Speech Kit did Receive Response")
    }
    
    func transaction(transaction: SKTransaction!, didReceiveAudio audio: SKAudio!) {
        print("Speech Kit did Receive Audio")
        session.audioPlayer.playAudio(audio)
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
    
    func speakStringOnce(chat:String){
        let options = [SKOptionsAutoPlayTTSKey: true];
        let _ = session.speakString(chat, withVoice: "Samantha", options:options, delegate: self)
    }
}
