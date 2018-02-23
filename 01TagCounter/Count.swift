//
//  Count.swift
//  01TagCounter
//
//  Created by gakki on 23/02/2018.
//  Copyright © 2018 gakki. All rights reserved.
//

import Foundation

class Count {
    var counting: Int
    
    init(){
        self.counting = 0
    }
    
    @objc func updateCount(_ notification: Notification) {
        guard let count = notification.userInfo!["count"] as? Count else{
            print("cant do add operation")
            return
        }
        count.counting += 1
    }
    
    @objc func initCount(_ notification: Notification){
        guard let count = notification.userInfo!["count"] as? Count else{
            print("cant do init operation")
            return
        }
        count.counting = 0
    }
}
