//
//  ViewController.swift
//  RhymeGame
//
//  Created by Sergii Gavryliuk on 2016-06-24.
//  Copyright © 2016 Sergey Gavrilyuk. All rights reserved.
//

import UIKit
import SpeechKit
import AVFoundation


class ViewController: UIViewController, SpeechKitManagerUpdateProtocol, UITableViewDataSource, UITableViewDelegate {

    var chatLog:[ChatItem] = []
    
    let tableView: UITableView = UITableView.init()
    let recordButton: UIButton = UIButton(type: .Custom)
    let cellReuseIdentifer = "Cell"
    
    var myScore:Int = 0
    var compScore:Int = 0
    
    let displayRecordingImageView: UIImageView = UIImageView(image: UIImage.init(named: "listenIcon"))
    
    let manager:SpeechKitManager = SpeechKitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self;
        
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifer)
        
        tableView.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 20 ).active = true
        tableView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: -150).active = true
        tableView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        
        self.view.addSubview(recordButton)
        recordButton.setImage(UIImage.init(named: "rmVoIPRecordButton-01-300x300"), forState: .Normal)
        recordButton.addTarget(self, action: #selector(record(_:)), forControlEvents: .TouchUpInside)
        recordButton.contentMode = UIViewContentMode.ScaleAspectFit
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        recordButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        recordButton.heightAnchor.constraintEqualToConstant(150).active = true
        recordButton.widthAnchor.constraintEqualToConstant(150).active = true
        
        self.view.addSubview(displayRecordingImageView)
        displayRecordingImageView.hidden = true
        displayRecordingImageView.contentMode = UIViewContentMode.Center
        
        displayRecordingImageView.translatesAutoresizingMaskIntoConstraints = false
        displayRecordingImageView.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        displayRecordingImageView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        displayRecordingImageView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        displayRecordingImageView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        
    }

    func speechKitManagerStateDidChange(state: SpeechKitManagerState, info: SKTransaction?) {
        
        switch(state) {
        case .Recording:
            displayRecordingImageView.hidden = false
            recordButton.hidden = true
            recordButton.userInteractionEnabled = false
        case .Ready, .Unknown, .Waiting:
            displayRecordingImageView.hidden = true
            recordButton.hidden = false
            recordButton.userInteractionEnabled = true
        }
    }
    
    func speechKitManagerUpdateChat(chat:String, isYou:Bool, points:Int) {
        
        let chatItem = ChatItem(text: chat, isYou: isYou, points:points)
        
        if (!isYou) {
            manager.speakStringOnce(chat)
        }
        chatLog.append(chatItem)
        tableView.reloadData()
        tableView.scrollToRowAtIndexPath(NSIndexPath.init(forItem: chatLog.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    func record(sender:UIButton) {
        
        manager.recordSpeech(SKTransactionSpeechTypeDictation, detection: .Short)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatLog.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifer) as UITableViewCell!
        
        cell.textLabel?.font = UIFont.systemFontOfSize(20)
        cell.textLabel?.text = chatLog[indexPath.row].text
        if(chatLog[indexPath.row].isYou) {
            cell.backgroundView = UIImageView(image: UIImage.init(named: "balloon_read_left")?.resizableImageWithCapInsets(UIEdgeInsets(top: 10,left: 17,bottom: 20, right: 17)))
       
        }else{
            cell.backgroundView = UIImageView(image: UIImage.init(named: "balloon_read_right")?.resizableImageWithCapInsets(UIEdgeInsets(top: 10,left: 17,bottom: 15,right: 17)))
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Score:\(myScore)"
    }
    
}

