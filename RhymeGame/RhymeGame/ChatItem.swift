//
//  ChatItem.swift
//  RhymeGame
//
//  Created by Kevin Kruusi on 2016-06-24.
//  Copyright © 2016 Sergey Gavrilyuk. All rights reserved.
//

import Foundation
import UIKit

struct ChatItem {
    
    let text:String
    let isYou:Bool
    let points:Int
    
    init(text:String, isYou:Bool, points:Int) {
        self.text = text
        self.isYou = isYou
        self.points = points
    }
}