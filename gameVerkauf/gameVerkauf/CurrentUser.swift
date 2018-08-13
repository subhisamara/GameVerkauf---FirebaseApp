//
//  CurrentUser.swift
//  gameVerkauf
//
//  Created by Subhi M. Samara on 21.06.17.
//
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseStorage

class CurrentUser {
    var _id:String = ""
    var _email:String = ""
    var userName:String = ""
    var profileurl = ""
    var userImage:UIImage = UIImage(named: "ProfileIMG")!
    
    static let instance = CurrentUser()
    
    func setUserImage() {
        let reference = DBProvider.Instance.dbRef
        let ref = reference.child("Users").child(self._id)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userInformation = snapshot.value as? NSDictionary {
                let urls = userInformation["profileImage"] as! String
                if let url = URL(string: urls){
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            self.userImage = image
                            //@TODO Profilfoto Notification
                            
                        }
                    }
                }
                
                NotificationsController.sendProfileImageURLReceivedNotification(url: urls)
            }
        })
    }
    
    func setNewUserImage(image: UIImage) {
        let newImage = Util.imageWithSize(image: image, size: CGSize(width: 150, height: 150))
        self.userImage = newImage
        
        //Upload To Firebase
        let data = UIImageJPEGRepresentation(newImage, 0.8)
        if data != nil {
            DBProvider.Instance.profileStorageRef.child(self._id + "-profile.jpg").put(data! , metadata: nil){ (metadata: FIRStorageMetadata?, err: Error?) in
                    if err != nil {
                        
                    } else {
                        print("Uploaded to Firebase")
                        DBProvider.Instance.usersRef.child(CurrentUser.instance._id).child("profileImage").setValue(metadata?.downloadURL()?.absoluteString)
                }
            }
        }
        
    }
    
    func setUser(user: FIRUser) {
        self._id = user.uid
        if user.email != nil {
            self._email = user.email!
        }
        setData()
        setUserImage()
    }
    
    
    func setData() {
        if self._id != "" {
            let reference = DBProvider.Instance.dbRef
            let ref = reference.child("Users").child(self._id)
            ref.observe(.value, with: { (snapshot) in
                if let userInformation = snapshot.value as? NSDictionary {
                    self.userName = userInformation["username"] as! String
                    NotificationsController.sendUserNameNotification(user: self.userName)
                }
                if let userInformation = snapshot.value as? String {
                    self.userName = userInformation
                }
            })
        }
    }
    
    func getID() -> String {
        return _id
    }
    
    func getEmail() -> String {
        return _email
    }
    
    
}
