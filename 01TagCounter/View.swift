//
//  View.swift
//  01TagCounter
//
//  Created by gakki on 23/02/2018.
//  Copyright © 2018 gakki. All rights reserved.
//

import UIKit

class View: UIView {

    var shouldSetupConstraints = true
    
    var countLabel: UILabel!
    
    var count =  Count()
    
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
    }
    
    // 设置位置限定
    private func addLabelConstraint(){
        //countLabel.sizeToFit()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    // 添加手势
    private func addLabelGesture(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(countTapped(gesture:)))
        let holdTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(countHoldZero(gesture:)))
        countLabel.addGestureRecognizer(tapRecognizer)
        countLabel.addGestureRecognizer(holdTapRecognizer)
        countLabel.isUserInteractionEnabled = true
    }
    
    //MARK: Actions
    // 点击action
    @objc func countTapped(gesture: UITapGestureRecognizer){
        
        NotificationCenter.default.post(name: NSNotification.Name("updateCount"), object: count, userInfo: ["count" : count])
        countLabel.text = String(count.counting)
        countLabel.font = UIFont.systemFont(ofSize: CGFloat(count.counting+40))
    }
    
    // 按压action
    @objc func countHoldZero(gesture: UILongPressGestureRecognizer){
        
        NotificationCenter.default.post(name: NSNotification.Name("initCount"), object: count, userInfo: ["count" : count])
        countLabel.text = String(count.counting)
        countLabel.font = UIFont.systemFont(ofSize: 40.0)
    }
    
    // MARK: Notification
    
    // 一个非常简单的调用Count方法而无需知道具体实现的observer between view and model
    func addLabelObserver(){
        NotificationCenter.default.addObserver(count, selector: #selector(Count.updateCount(_:)), name: Notification.Name("updateCount"), object: nil)
        NotificationCenter.default.addObserver(count, selector: #selector(Count.initCount(_:)), name: NSNotification.Name("initCount"), object: nil)
    }
    
    
}
