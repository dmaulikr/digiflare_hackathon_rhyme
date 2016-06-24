//
//  RHDispatchUtility.swift
//  appletv
//
//  Created by Kevin Kruusi on 2016-01-26.
//  Copyright © 2016 Rogers. All rights reserved.
//

import Foundation

func run_on_main(block:dispatch_block_t)->Void{
    if(NSThread.isMainThread()){
        block()
    }else{
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
}

func run_on_background(block:dispatch_block_t)->Void{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
}