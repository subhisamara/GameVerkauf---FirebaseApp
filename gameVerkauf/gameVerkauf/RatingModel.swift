//
//  RatingModel.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 11.07.17.
//
//
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class RatingModel {
    static let shared = RatingModel()
    
    init() {
        //self.listenToEntriesDatabase()
    }
    
    func saveEntryToDatabase(ratingEntry: RatingEntry) {
        let reference = DBProvider.Instance.dbRef
        let data = ratingEntry.getDictionary()
        reference.child("rating").child(ratingEntry.user).child(CurrentUser.instance.getID()).setValue(data) {
            (error, reference) in
                //Set Notification
                if error != nil {
                    //Fehlerfall
                    //@TODO Notification
                        
                } else {
                    //@Todo Notification
                    RatingModel.shared.getRatingsForUserId(userId: ratingEntry.user)
                }
        }
    }
    
    func getRatingsForUserId(userId: String) {
        let reference = DBProvider.Instance.dbRef
        let ref = reference.child("rating").child(userId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            var entriesArray:[RatingEntry] = []
            
            var rating = 0
            for snap in snapshot.children {
                let entry = (snap as! FIRDataSnapshot).value as! NSDictionary
                let ratingEntry = RatingEntry(rating: entry["rating"] as! Int, creator: entry["creator"] as! String, name: entry["name"] as! String, user: entry["user"] as! String, description: entry["description"] as! String, created: entry["created"] as! String)
                entriesArray.append(ratingEntry)
                rating += ratingEntry.rating
                
                if ratingEntry.creator == CurrentUser.instance.getID() {
                    NotificationsController.sendFormerRatingNotification(ratings: ratingEntry)
                }
                
            }
            NotificationsController.sendRatingReceivedNotification(ratings: entriesArray)
            
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
                
                let gameEntry = GameEntry(name: entry["name"] as! String, genre: GenreType(rawValue: entry["genre"] as! String)!, console: ConsoleType(rawValue: entry["platform"] as! String)!, price: Float(entry["price"] as! String)!, type: EntryType(rawValue: entry["type"] as! String)!, imageUrl: entry["image"] as! String, description: entry["description"] as! String, owner: entry["owner"] as! String, ownerName:entry["ownerName"] as! String, date:Date(timeIntervalSince1970: Double(entry["date"] as! String)!))
                entriesArray.append(gameEntry)
                
            }
            NotificationsController.sendMyEntriesDownloaded(entries: entriesArray)
        })
    }
    
}
