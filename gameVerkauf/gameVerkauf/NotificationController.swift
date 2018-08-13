//
//  NotificationController.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 25.05.17.
//  Copyright © 2017 Fabian Frey. All rights reserved.
//

import Foundation
import FirebaseAuth

class NotificationsController {
    
    static func sendUserLoginNotification(user: FIRUser) {
        let newUserLoginNotification = Notification(name: Notification.Name(rawValue: "UserLogin"), object: user)
        let notificationCenter = NotificationCenter.default
        CurrentUser.instance.setUser(user: user)
        CurrentUser.instance.setData()
        notificationCenter.post(newUserLoginNotification)
    }
    
    static func sendUserErrorLogin(error: NSError) {
        print("User not logged in")
        let newUserLoginNotification = Notification(name: Notification.Name(rawValue: "UserLoginError"), object: error)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newUserLoginNotification)
    }
    
    static func platformPickedNotification(type: ConsoleType) {
        let newNotification = Notification(name: Notification.Name(rawValue: "PlatformPicked"), object: type)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func genrePickedNotification(type: GenreType) {
        let newNotification = Notification(name: Notification.Name(rawValue: "GenrePicked"), object: type)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func sendEntrySavedNotification(entry: GameEntry) {
        let newNotification = Notification(name: Notification.Name(rawValue: "SavedEntry"), object: entry)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func sendEntrySavedErrorNotification(error: NSError) {
        let newNotification = Notification(name: Notification.Name(rawValue: "SavedEntryError"), object: error)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func sendAllEntriesDownloaded(entries: [GameEntry]) {
        let newNotification = Notification(name: Notification.Name(rawValue: "getAllEntries"), object: entries)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func sendMyEntriesDownloaded(entries: [GameEntry]){
        let newNotification = Notification(name: Notification.Name(rawValue: "getMyEntries"), object: entries)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }

    static func reloadEntriesTableViewData() {
        let newNotification = Notification(name: Notification.Name(rawValue: "reloadEntriesData"), object: nil)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func sendFilteredData(filteredData : FilterObject){
        let newNotification = Notification(name: Notification.Name(rawValue: "filterData"), object: filteredData)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    static func sendUserNameNotification(user:String) {
        let newUserNameNotification = Notification(name: Notification.Name(rawValue: "UserName"), object: user)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newUserNameNotification)
    }

    static func sendUserNameError(error: NSError) {
        print("UserName not successful")
        let newUserNameNotification = Notification(name: Notification.Name(rawValue: "UserNameError"), object: error)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newUserNameNotification)
    }
    
    static func apiGameSelectedNotification(game: NSDictionary) {
        let newUserNameNotification = Notification(name: Notification.Name(rawValue: "GetApiEntry"), object: game)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newUserNameNotification)
    }
    
    static func sendUcall_numberNotification(call_number:String) {
        let newcall_numberNotification = Notification(name: Notification.Name(rawValue: "call_number"), object: call_number)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newcall_numberNotification)
    }
    
    static func sendcall_numberError(error: NSError) {
        print("UserName not successful")
        let newcall_numberNotification = Notification(name: Notification.Name(rawValue: "call_numberError"), object: error)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newcall_numberNotification)
    }
    
    static func sendUserEmailNotification(email:String) {
        let newUserEmailNotification = Notification(name: Notification.Name(rawValue: "User_Email"), object: email)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newUserEmailNotification)
    }
    
    static func sendUserEmailError(error: NSError) {
        print("UserName not successful")
        let newUserEmailNotification = Notification(name: Notification.Name(rawValue: "UserNameError"), object: error)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newUserEmailNotification)
    }
    
    static func sendRatingReceivedNotification(ratings: [RatingEntry]) {
        let newNotification = Notification(name: Notification.Name(rawValue: "Rating"), object: ratings)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func sendFormerRatingNotification(ratings: RatingEntry) {
        let newNotification = Notification(name: Notification.Name(rawValue: "OwnRating"), object: ratings)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func sendProfileImageURLReceivedNotification(url:String) {
        let newNotification = Notification(name: Notification.Name(rawValue: "url"), object: url)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func sendProfileImageURLReceivedNotification(url: URL) {
        let newNotification = Notification(name: Notification.Name(rawValue: "ProfilePhotoDownloaded"), object: url)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func videoIDFound(_ videoID: String) {
        let newNotification = Notification(name: Notification.Name(rawValue: "YouTubeLoad"), object: videoID)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func videoIDNotFound(){
        let newNotification = Notification(name: Notification.Name(rawValue: "YouTubeError"), object: nil)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func sendNoUserNotification() {
        let newNotification = Notification(name: Notification.Name(rawValue: "NoUsername"), object: nil)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
    
    static func reloadFilterViewData(type: Int) {
        let newNotification = Notification(name: Notification.Name(rawValue: "reloadFilter"), object: type)
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(newNotification)
    }
 
}

