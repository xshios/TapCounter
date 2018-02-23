//
//  View.swift
//  01TagCounter
//
//  Created by gakki on 23/02/2018.
//  Copyright © 2018 gakki. All rights reserved.
//

import UIKit

extension Notification.Name{
    static let updateTime = Notification.Name("updateTime")
    static let initTime = Notification.Name("initTime")
    static let updateCount = Notification.Name("updateCount")
    static let initCount = Notification.Name("initCount")
    static let stopCount = Notification.Name("stopCount")
}

struct Constant {
    static let time = "time"
    static let count = "count"
}

class View: UIView {

    var shouldSetupConstraints = true
    
    // MARK: VIEWS
    var countLabel: UILabel!
    var timeLabel: UILabel!
    var recordLabel: UILabel!
    var count =  Count()
    var topScore: Record!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabel()
        addLabelConstraint()
        addLabelGesture()
        addLabelObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLabel()
        addLabelConstraint()
        addLabelGesture()
        addLabelObserver()
    }
    
    //MARK: label
    // 初始化
    private func initLabel(){
        countLabel = UILabel(frame: CGRect.zero)
        countLabel.text = String(count.counting)
        countLabel.textColor = .black
        countLabel.font = UIFont.systemFont(ofSize: 40.0)
        self.addSubview(countLabel)
        
        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.text = count.time
        timeLabel.textColor = .black
        countLabel.font = UIFont.systemFont(ofSize: 40.0)
        self.addSubview(timeLabel)
        
        recordLabel = UILabel(frame: CGRect.zero)
        reloadRecord()
        recordLabel.textColor = .black
        recordLabel.font = UIFont.systemFont(ofSize: 40.0)
        self.addSubview(recordLabel)
        
    }
    
    private func reloadRecord(){
        if let record = loadRecord(){
            recordLabel.text = String(format: "Record : %03i",  record)
            topScore = Record(record: record)
        }else{
            recordLabel.text = "Record : 000"
            topScore = Record(record: 0)
        }
    }
    // 设置位置限定
    private func addLabelConstraint(){
        //countLabel.sizeToFit()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: 4.0).isActive = true
        
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        recordLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        recordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    // 添加手势
    private func addLabelGesture(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(countTapped(gesture:)))
        let holdRecognizerToClearCount = UILongPressGestureRecognizer(target: self, action: #selector(countHoldZero(gesture:)))
        self.addGestureRecognizer(tapRecognizer)
        self.isUserInteractionEnabled = true
        countLabel.addGestureRecognizer(holdRecognizerToClearCount)
        countLabel.isUserInteractionEnabled = true
        let holdRecognizerToClearRecord = UILongPressGestureRecognizer(target: self, action: #selector(clearRecord(gesture:)))
        recordLabel.isUserInteractionEnabled = true
        recordLabel.addGestureRecognizer(holdRecognizerToClearRecord)
    }
    
    //MARK: Actions
    // 点击action
    @objc func countTapped(gesture: UITapGestureRecognizer){
        NotificationCenter.default.post(name: .updateCount, object: nil)
        countLabel.text = String(count.counting)
        countLabel.font = UIFont.systemFont(ofSize: CGFloat(count.counting/10+40))
        timeLabel.text = count.time
        if count.counting > topScore.record {
            recordLabel.text = String(format: "Record : %03i",  count.counting)
        }
    }
    
    // 按压action
    @objc func countHoldZero(gesture: UILongPressGestureRecognizer){
        if count.counting > topScore.record {
            let saved = NSKeyedArchiver.archiveRootObject(count.counting, toFile: Record.ArchiveURL.path)
            if saved{
                //print("save records")
                topScore.record = count.counting
            }
        }
        NotificationCenter.default.post(name: .initCount, object: nil)
        countLabel.text = String(count.counting)
        countLabel.font = UIFont.systemFont(ofSize: 40.0)
        timeLabel.text = count.time
    }
    
    @objc func clearRecord(gesture: UILongPressGestureRecognizer){
        NSKeyedArchiver.archiveRootObject(0, toFile: Record.ArchiveURL.path)
        reloadRecord()
    }
    
    // MARK: Notification
    
    // 一个非常简单的调用Count方法而无需知道具体实现的observer between view and model
    func addLabelObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.listenToTimer(_:)), name: .updateTime, object: nil)
    }
    
    @objc func listenToTimer(_ notification: Notification){
        guard let timeString = notification.userInfo![Constant.time] as? String else{
            print("void time")
            return
        }
        timeLabel.text = timeString
    }
    
    // MARK: Load history
    private func loadRecord() -> Int? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Record.ArchiveURL.path) as? Int
    }
    
    
    
}
