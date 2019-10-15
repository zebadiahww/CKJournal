//
//  Entry.swift
//  CKJournal
//
//  Created by Zebadiah Watson on 10/14/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import Foundation
import CloudKit

struct EntryConstants{
    static let TitleKey = "titleText"
    static let BodyKey = "bodyText"
    static let TimeStampKey = "timeStamp"
    static let RecordType = "Entry"
}

class Entry {
    
    let titleText: String
    let bodyText: String
    let timeStamp: Date
    let ckRecordID: CKRecord.ID
    
    init(titleText: String, bodyText: String, timeStamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.titleText = titleText
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.ckRecordID = ckRecordID
    }
    
    
} // END OF CLASS

extension Entry {
    
    convenience init?(ckRecord: CKRecord) {
        guard let titleText = ckRecord[EntryConstants.TitleKey] as? String,
            let bodyText = ckRecord[EntryConstants.BodyKey] as? String,
            let timeStamp = ckRecord[EntryConstants.TimeStampKey] as? Date
            else { return nil }
        
        self.init(titleText: titleText, bodyText: bodyText, timeStamp: timeStamp)
    }
}

extension CKRecord {
    convenience init(entry: Entry){
        self.init(recordType: EntryConstants.RecordType, recordID: entry.ckRecordID)
        self.setValue(entry.titleText, forKey: EntryConstants.TitleKey)
        self.setValue(entry.bodyText, forKey: EntryConstants.BodyKey)
        self.setValue(entry.timeStamp, forKey: EntryConstants.TimeStampKey)
    }
}


extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
