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
    var time: String = "01:00:00"
    var seconds = 60.0
    var timer = Timer()
    var isTimerRunning = false
    let timeInterval = 0.01
    init(){
        self.counting = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCount(_:)), name: .updateCount, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.initCount(_:)), name: .initCount, object: nil)
    }
    
    @objc func updateCount(_ notification: Notification) {
        if counting == 0{
            runTimer()
            isTimerRunning = true
        }
        if isTimerRunning{
            counting += 1
        }
    }
    
    @objc func initCount(_ notification: Notification){
        counting = 0
        initTimer()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        postTime()
    }
    
    @objc func updateTimer() {
        seconds -= timeInterval
        let minsInt = Int(seconds) / 60
        let secondsInt = Int(seconds) - 60 * minsInt
        let minuSecondsInt = Int(100 * (seconds - Double(minsInt * 60) - Double(secondsInt)))
        if(seconds <= 0.0){
            timer.invalidate()
            isTimerRunning = false
        }
        time = String(format:"%02i:%02i:%02i", minsInt, secondsInt, minuSecondsInt)
        NotificationCenter.default.post(name: .updateTime, object: nil, userInfo: [Constant.time:time])
    }
    func postTime(){
        
    }
    
    func initTimer(){
        timer.invalidate()
        isTimerRunning = false
        seconds = 60.0
        time = "01:00:00"
    }
}
