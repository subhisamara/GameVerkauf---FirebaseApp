//
//  GoogleLoginModule.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 5/26/17.
//
//

import Foundation
import Firebase
import Google
import GoogleSignIn

class GoogleLoginModule{
    
    func loginSuccess(googleUser: GIDGoogleUser){
        
        guard let authentication = googleUser.authentication else {return}
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signIn(with: credential){ (user, error) in
            if error != nil {
                PopupModel.newNotificationWithOneButton("Error", message: "An error has occured while logging in via Google: \(String(describing: error?.localizedDescription))", buttonMessage: "Okay")
                return
            }
            
            
            if let firUser = user {
                DBProvider.Instance.getUsernameById(userId: firUser.uid)
            }
            
        }
    }
    
}
