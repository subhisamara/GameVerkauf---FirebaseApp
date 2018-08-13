//
//  EntryModel.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 24.06.17.
//
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class EntryModel {
    static let shared = EntryModel()
    
    init() {
        self.listenToEntriesDatabase()
    }
    
    func saveEntryToDatabase(gameEntry: GameEntry) {
        let userId = FIRAuth.auth()?.currentUser
        let reference = DBProvider.Instance.dbRef
        
        let data = UIImageJPEGRepresentation(gameEntry.image, 0.8)
        let metaData = FIRStorageMetadata()
        let path:String = "entryImages/\(randomAlphaNumericString(length: 20))"
        metaData.contentType = "image/jpg"
        DBProvider.Instance.storageRef.child(path).put(data!, metadata: metaData)
        { (metaData,error) in
            if let error = error {
                NotificationsController.sendEntrySavedErrorNotification(error: error as NSError)
                return
            } else {
                let downloadURL:String = metaData!.downloadURL()!.absoluteString
                //Create Dictionary
                let data = gameEntry.getDictionary(url: downloadURL)
                reference.child("entries").child(userId!.uid).childByAutoId().setValue(data) {
                    (error, reference) in
                    //Set Notification
                    if error != nil {
                        //Fehlerfall
                        NotificationsController.sendEntrySavedErrorNotification(error: (error as NSError?)!)
                    } else {
                        NotificationsController.sendEntrySavedNotification(entry: gameEntry)
                    }
                }
            }
        }
    }
    
    func getAllEntries() {
        let reference = DBProvider.Instance.dbRef
        let ref = reference.child("entries")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            var entriesArray:[GameEntry] = []
            
            for snap in snapshot.children {
                let entrysnap = snap as! FIRDataSnapshot
                for gameEntrySnap in entrysnap.children {
                    let entry = (gameEntrySnap as! FIRDataSnapshot).value as! NSDictionary
                    
                    let gameEntry = GameEntry(name: entry["name"] as! String, genre: GenreType(rawValue: entry["genre"] as! String)!, console: ConsoleType(rawValue: entry["platform"] as! String)!, price: Float(entry["price"] as! String)!, type: EntryType(rawValue: entry["type"] as! String)!, imageUrl: entry["image"] as! String, description: entry["description"] as! String, owner: entry["owner"] as! String,ownerName: entry["ownerName"] as! String, date:Date(timeIntervalSince1970: Double(entry["date"] as! String)!))
                    entriesArray.append(gameEntry)
                }
            }
            NotificationsController.sendAllEntriesDownloaded(entries: entriesArray)
        })
    }
    
    func getMyEntries(){
        let reference = DBProvider.Instance.dbRef
        let ref = reference.child("entries").child(Constants.CURRENTUSER_ID!)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            var entriesArray:[GameEntry] = []
            
            for snap in snapshot.children {
                    let entry = (snap as! FIRDataSnapshot).value as! NSDictionary
                    
                    let gameEntry = GameEntry(name: entry["name"] as! String, genre: GenreType(rawValue: entry["genre"] as! String)!, console: ConsoleType(rawValue: entry["platform"] as! String)!, price: Float(entry["price"] as! String)!, type: EntryType(rawValue: entry["type"] as! String)!, imageUrl: entry["image"] as! String, description: entry["description"] as! String, owner: entry["owner"] as! String,ownerName: entry["ownerName"] as! String,date:Date(timeIntervalSince1970: Double(entry["date"] as! String)!))
                    entriesArray.append(gameEntry)
                
            }
            NotificationsController.sendMyEntriesDownloaded(entries: entriesArray)
        })
    }
    
    func listenToEntriesDatabase() {
        let reference = DBProvider.Instance.dbRef
        let ref = reference.child("entries")
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            var entriesArray:[GameEntry] = []
            for snap in snapshot.children {
                let entrysnap = snap as! FIRDataSnapshot
                for gameEntrySnap in entrysnap.children {
                    let entry = (gameEntrySnap as! FIRDataSnapshot).value as! NSDictionary
                    
                    let gameEntry = GameEntry(name: entry["name"] as! String, genre: GenreType(rawValue: entry["genre"] as! String)!, console: ConsoleType(rawValue: entry["platform"] as! String)!, price: Float(entry["price"] as! String)!, type: EntryType(rawValue: entry["type"] as! String)!, imageUrl: entry["image"] as! String, description: entry["description"] as! String, owner: entry["owner"] as! String,ownerName: entry["ownerName"] as! String,date:Date(timeIntervalSince1970: Double(entry["date"] as! String)!))
                    entriesArray.append(gameEntry)
                }
            }
            NotificationsController.sendAllEntriesDownloaded(entries: entriesArray)
        })
    }
    
    
    //@TODO Auslagern in util.swift
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
}
