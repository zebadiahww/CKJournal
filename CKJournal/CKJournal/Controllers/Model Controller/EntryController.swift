//
//  EntryController.swift
//  CKJournal
//
//  Created by Zebadiah Watson on 10/14/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    // Properties
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // Shared Instance
    static let shared = EntryController()
    
    // SOT
    var entries: [Entry] = []
    
    
    // Save or Create
    
    func saveEntry(titleText: String, bodyText: String, completion: @escaping (_ success: Bool) -> Void) {
        let newEntry = Entry(titleText: titleText, bodyText: bodyText)
        let entryRecord = CKRecord(entry: newEntry)
        privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record, let savedEntry = Entry(ckRecord: record)
                else { completion(false) ; return }
            
            self.entries.append(savedEntry)
            print("saved Entry Successfully")
            completion(true)
        }
    }
    
    // Fetch
    
    func fetchEntries(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.RecordType, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let records = foundRecords else {
                completion(false); return }
            
            let entries = records.compactMap( { Entry(ckRecord: $0) } )
            
            self.entries = entries
            print("fetched successfully")
            completion(true)
        }
    }
    
    func removeEntry(entry: Entry) {
        guard let indexToRemove = entries.firstIndex(of: entry) else { return }
        entries.remove(at: indexToRemove)
        privateDB.delete(withRecordID: entry.ckRecordID) { (ckRecordID, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else { return }
        }
    }
    
    
//    func modifyEntry(entry: Entry){
//        let entryRecord = CKRecord(entry: entry)
//        let operation = CKModifyRecordsOperation(recordsToSave: [entryRecord], recordIDsToDelete: nil)
//        publicDB.add(operation)
//
//
//    }

}// END OF CLASS

