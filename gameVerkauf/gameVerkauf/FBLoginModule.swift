//
//  FBLoginModule.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 5/25/17.
//  Copyright © 2017 Adam Mahmoud. All rights reserved.
//

import Foundation
import Firebase
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit

class FBLoginModule{
    
    func loginSuccess() {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) {(user, error) in
            
            if error != nil {
                PopupModel.newNotificationWithOneButton("Error", message: "An error has occured while logging in via Facebook: \(String(describing: error?.localizedDescription))", buttonMessage: "Okay")
                return
            }
            
            if let firUser = user {
                DBProvider.Instance.getUsernameById(userId: firUser.uid)
            }
            
        }
    }
    
}
