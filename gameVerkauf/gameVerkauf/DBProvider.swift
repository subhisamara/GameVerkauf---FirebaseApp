//
//  DBProvider.swift
//  gameVerkauf
//
//
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

protocol FetchData: class{
    
    func dataReceived(recievedContacts: [Contact])
    
}

class DBProvider{
    
    private static let _instance = DBProvider();
    
    
    private init(){}
    
    weak var delegate: FetchData?
    
    static var Instance: DBProvider{
        return _instance;
    }
    
    var dbRef: FIRDatabaseReference{
        return FIRDatabase.database().reference()
    }
    
    
    var usersRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS)
    }
    
    var userRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!)
    }
    
    var userEmailRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.EMAIL)
    }
    
    var userNameRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.USERNAME)
    }
    
    func persistenceEnabled() {
        FIRDatabase.database().persistenceEnabled = true
    }
    
    var userContactsRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS)
    }
    
    var userContactIDRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS).child(CurrentContact.instance.ID)
    }
    
    var userContactNameRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS).child(CurrentContact.instance.ID).child(Constants.CONTACT_NAME)
    }
    
    var userContactEmailRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS).child(CurrentContact.instance.ID).child(Constants.CONTACT_EMAIL)
    }
    
    var userMessagesRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS).child(CurrentContact.instance.ID).child(Constants.MESSAGES)
    }
    
    var userMessagesMirrorRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(CurrentContact.instance.ID).child(Constants.CONTACTS).child(Constants.CURRENTUSER_ID!).child(Constants.MESSAGES)
    }
    
    var userMessageRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS).child(CurrentContact.instance.ID).child(Constants.MESSAGES).child(Constants.MESSAGE_ID)
    }
    
    var MessageSenderNameRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS).child(CurrentContact.instance.ID).child(Constants.MESSAGES).child(Constants.MESSAGE_ID).child(Constants.SENDER_NAME)
    }
    
    var MessageSenderIDRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS).child(CurrentContact.instance.ID).child(Constants.MESSAGES).child(Constants.MESSAGE_ID).child(Constants.SENDER_ID)
    }
    
    var MessageTextRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS).child(CurrentContact.instance.ID).child(Constants.MESSAGES).child(Constants.MESSAGE_ID).child(Constants.TEXT)
    }
    
    var mediaMessagesRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS).child(CurrentContact.instance.ID).child(Constants.MESSAGES).child(Constants.MEDIA_MESSAGES_ID)
    }
    
    var mediaMessageMirrorRef: FIRDatabaseReference{
        return dbRef.child(Constants.USERS).child(CurrentContact.instance.ID).child(Constants.CONTACTS).child(Constants.CURRENTUSER_ID!).child(Constants.MESSAGES).child(Constants.MEDIA_MESSAGES_ID)
    }
    
    
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference(forURL :"gs://gamerszone-86add.appspot.com")
    }
    
    var imageStorageRef: FIRStorageReference{
        return storageRef.child(Constants.IMAGE_STORAGE)
    }
    
    var profileStorageRef: FIRStorageReference{
        return storageRef.child("profilePhotos")
    }
        
    func getUserNameById(_id:String){
    }
    
    func saveContact(userID: String,email: String){
        DBProvider.Instance.dbRef.child(Constants.USERS).child(userID).child(Constants.USERNAME).observeSingleEvent(of: .value, with:{ FIRDataSnapshot  in
            let username = FIRDataSnapshot.value as? String
            let data: Dictionary<String,Any> = [Constants.USERNAME: username!, Constants.EMAIL:email]
            if Constants.CURRENTUSER_ID! != userID {
                self.usersRef.child(Constants.CURRENTUSER_ID!).child(Constants.CONTACTS).child(userID).setValue(data)
                
            }
        })
    }
    
    func saveContactMirror(userID: String,email: String){
        DBProvider.Instance.dbRef.child(Constants.USERS).child((FIRAuth.auth()?.currentUser?.uid)!).child(Constants.USERNAME).observeSingleEvent(of: .value, with:{ FIRDataSnapshot  in
            let username = FIRDataSnapshot.value as? String
            
            let data: Dictionary<String,Any> = [Constants.USERNAME: username!, Constants.EMAIL: email]
            self.usersRef.child(userID).child(Constants.CONTACTS).child(Constants.CURRENTUSER_ID!).setValue(data)

        })
    }
    
    func observeContacts() {
        userContactsRef.observe(FIRDataEventType.value, with: {
            (snapshot) in
            var contacts = [Contact]();
            if let myUsers = snapshot.value as? NSDictionary{
                for(key,value) in myUsers {
                    if let contactData = value as? NSDictionary
                    {
                        if let email = contactData[Constants.EMAIL] as? String{
                            let id = key as! String
                            let newContact = Contact(id: id, email: email)
                            contacts.append(newContact)
                        }
                    }
                }
            }
            self.delegate?.dataReceived(recievedContacts: contacts)
        })
        
        userContactsRef.keepSynced(true)
    }
    
    
    func getContacts(){
        self.userContactsRef.observeSingleEvent(of: FIRDataEventType.value) {
            (snapshot: FIRDataSnapshot) in
            var contacts = [Contact]();
            if let myUsers = snapshot.value as? NSDictionary{
                for(key,value) in myUsers {
                    if let contactData = value as? NSDictionary
                    {
                        if let email = contactData[Constants.EMAIL] as? String{
                            let id = key as! String
                            let newContact = Contact(id: id, email: email)
                            contacts.append(newContact)
                        }
                    }
                }
            }
            self.delegate?.dataReceived(recievedContacts: contacts)
        }
        
    }
    
    func getUserProfilePhotoById(userId: String) {
        let reference = DBProvider.Instance.dbRef
        let ref = reference.child("Users").child(userId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userInformation = snapshot.value as? NSDictionary {
                let urls = userInformation["profileImage"] as! String
                if let url = URL(string: urls){
                    NotificationsController.sendProfileImageURLReceivedNotification(url: url)
                }
            }
        })
    }
    
    func getUsernameById(userId: String) {
        let reference = DBProvider.Instance.dbRef
        let ref = reference.child("Users").child(userId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userInformation = snapshot.value as? NSDictionary {
                //Eintrag in der Datenbank, es muss einen Usernamen existieren
                if let name = userInformation["username"] as? String {
                    print("Variante 1")
                    NotificationsController.sendUserNameNotification(user: name)
                } else {
                    print("Variante 3")
                    NotificationsController.sendNoUserNotification()
                }
            } else {
                print("Variante 2")
                NotificationsController.sendNoUserNotification()
            }
        })
    }
    
}
