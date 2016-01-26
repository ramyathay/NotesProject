//
//  Notes.swift
//  NotesClone
//
//  Created by Ramyatha Yugendernath on 1/25/16.
//  Copyright © 2016 Ramyatha Yugendernath. All rights reserved.
//

import Foundation

class Notes: NSObject, NSCoding {
    static var key: String = "Notes"
    static var schema: String = "NotesList"
    
    var notesText: String
    var createdAt: NSDate
    // use this init for creating a new Notes
    init(newNote: String) {
        notesText = newNote
        createdAt = NSDate()
    }
    // MARK: - NSCoding protocol
    // used for encoding (saving) objects
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(notesText, forKey: "notesText")
        aCoder.encodeObject(createdAt, forKey: "createdAt")
    }
    // used for decoding (loading) objects
    required init?(coder aDecoder: NSCoder) {
        notesText = aDecoder.decodeObjectForKey("notesText") as! String
        createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate
        super.init()
    }
    // MARK: - Queries
    static func all() -> [Notes] {
        var Notess = [Notes]()
        let path = Database.dataFilePath(Notes.schema)
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                Notess = unarchiver.decodeObjectForKey(Notes.key) as! [Notes]
                unarchiver.finishDecoding()
            }
        }
        return Notess
    }
    func save() {
        var NotessFromStorage = Notes.all()
        var exists = false
        var tempIndex = 0
        
        for var i = NotessFromStorage.count - 1; i >= 1 ; i-- {
            print(i,NotessFromStorage[i].createdAt,self.createdAt)
            if NotessFromStorage[i].createdAt == self.createdAt {
                exists = true
                tempIndex = i
                print(i)
            }
        }
        if !exists {
            NotessFromStorage.append(self)
            for var i = NotessFromStorage.count - 1; i >= 1 ; i-- {
                NotessFromStorage[i ] = NotessFromStorage[i - 1]
            }
            NotessFromStorage[0] = self
        }
        else {
            let result = NotessFromStorage.removeAtIndex(tempIndex)
            let lastNote = NotessFromStorage[NotessFromStorage.count - 1]
    
            for var i = NotessFromStorage.count - 1; i >= 1 ; i-- {
                
                NotessFromStorage[i] = NotessFromStorage[i - 1]
            }
            NotessFromStorage.append(lastNote)
            NotessFromStorage[0] = self
            exists = false
        }
        
        print("Value of self is \(self.notesText) \(self.createdAt)")
        
        
        Database.save(NotessFromStorage, toSchema: Notes.schema, forKey: Notes.key)
    }
    func destroy() {
        var NotesFromStorage = Notes.all()
        for var i = 0; i < NotesFromStorage.count; ++i {
            if NotesFromStorage[i].createdAt == self.createdAt {
                NotesFromStorage.removeAtIndex(i)
            }
        }
        Database.save(NotesFromStorage, toSchema: Notes.schema, forKey: Notes.key)
    }
}