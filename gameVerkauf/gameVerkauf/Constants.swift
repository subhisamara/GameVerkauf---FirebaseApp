//
//  Constants.swift
//  gameVerkauf
//
//  Created by Karam Shabita on 04.06.17.
//
//

import Foundation
import FirebaseAuth

class Constants{
    
    static var CURRENTUSER_ID = FIRAuth.auth()?.currentUser?.uid
    static let USERS = "Users"
    static let EMAIL = "User_Email"
    static var USERNAME = "username"
    
    
    static let CONTACTS = "Contacts"
    static let CONTACT_NAME = "Contact_name"
    static let CONTACT_EMAIL = "Contact_name"
    
    
    static let MESSAGES = "Messages"
    static let MESSAGE_ID = "Message_id"
    static let SENDER_NAME = "Sender_Name"
    static let SENDER_ID = "Sender_id"
    static let TEXT = "Text"
    
    //static let MESSAGE_TIME = "Message_Time"
    
    //static let ITEMS = "Items"
    
    
    static let MEDIA_MESSAGES_ID = "Media_Messages"
    static let IMAGE_STORAGE = "Image_Messages"
    static let URL = "url"
    
    
    
}
