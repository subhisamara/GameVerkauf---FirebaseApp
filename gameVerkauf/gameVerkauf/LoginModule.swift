//
//  LoginModule.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 25.05.17.
//  Copyright © 2017 Fabian Frey. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginModule {
    
    static let shared = LoginModule()
    
    func checkLogin(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                NotificationsController.sendUserErrorLogin(error: err as NSError)
            } else {
                NotificationsController.sendUserLoginNotification(user: user!)
                //DBProvider.Instance.saveUser(userID: user!.uid, email: email)
            }
        }
    }
    
    func createUserWith(email: String, password: String, username: String) {
        FIRAuth.auth()!.createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                switch error!._code {
                    case FIRAuthErrorCode.errorCodeInvalidEmail.rawValue:
                        PopupModel.newNotificationWithOneButton("Error", message: "The email address you entered is invalid.", buttonMessage: "Try Again")
                    case FIRAuthErrorCode.errorCodeEmailAlreadyInUse.rawValue:
                        PopupModel.newNotificationWithOneButton("Error", message: "The email address you entered is already in use.", buttonMessage: "Try again")
                    case FIRAuthErrorCode.errorCodeOperationNotAllowed.rawValue:
                        PopupModel.newNotificationWithOneButton("Error", message: "Operation not allowed.", buttonMessage: "Okay")
                    case FIRAuthErrorCode.errorCodeWeakPassword.rawValue:
                        PopupModel.newNotificationWithOneButton("Error", message: "The password you entered is too weak.", buttonMessage: "Try Again")
                    default:  //Should never appear (for testing only)
                        print(error.debugDescription)
                        PopupModel.newNotificationWithOneButton("Error", message: "An error has occured while registering.", buttonMessage: "Try Again")
                    
                }
            } else {
                let url = "https://firebasestorage.googleapis.com/v0/b/gamerszone-86add.appspot.com/o/profilePhotos%2Fprofpic.png?alt=media&token=39ff50b6-6cb8-4892-a34b-f50410dd749a"
                let userInformation:[String:String] = ["User_Email":email , "username" : username,"call_number":"Unavailable","profileImage": url]
                
                DBProvider.Instance.dbRef.child("Users").child(user!.uid).setValue(userInformation) { (error, ref) -> Void in
                    //@TODO Wieder Löschen wenn Probleme?
                    //Sonst Nutzer Angemeldet und registriert, aber kein Feedback dazu!
                    if error == nil {
                        NotificationsController.sendUserLoginNotification(user: user!)
                    }
                    
                }
            }
        }
        
    }
    
}
