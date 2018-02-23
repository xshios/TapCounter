//
//  File.swift
//  01TagCounter
//
//  Created by gakki on 23/02/2018.
//  Copyright © 2018 gakki. All rights reserved.
//

import Foundation

class Record: NSObject, NSCoding {
    var record: Int
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    struct PropertyKey {
        static let record = "record"
    }
    
    init?(record: Int){
        guard record >= 0 else{
            return nil
        }
        self.record = record
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(record, forKey: PropertyKey.record)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let record = aDecoder.decodeInteger(forKey: PropertyKey.record)
        
        self.init(record: record)
    }
}
