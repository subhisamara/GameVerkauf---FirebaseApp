//
//  PasswordResetViewController.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 6/4/17.
//
//

import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField

class PasswordResetViewController: UIViewController {
    
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.placeholder = "Email Address"
        self.emailField.title = "Your Email"
        emailField.autocorrectionType = .no
        emailField.keyboardType = .emailAddress

    
    }

    @IBAction func pressed(_ sender: Any) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: emailField.text!){ error in
            if error != nil {
                switch error!._code {
                case FIRAuthErrorCode.errorCodeInvalidEmail.rawValue:
                    PopupModel.newNotificationWithOneButton("Error", message: "The email address you entered is invalid.", buttonMessage: "Try Again")
                case FIRAuthErrorCode.errorCodeInvalidSender.rawValue:
                    PopupModel.newNotificationWithOneButton("Error", message: "The sender email is invalid.", buttonMessage: "Okay")
                case FIRAuthErrorCode.errorCodeInvalidMessagePayload.rawValue:
                    PopupModel.newNotificationWithOneButton("Error", message: "The email template payload is invalid.", buttonMessage: "Okay")
                    
                default:
                    print(error.debugDescription)
                    PopupModel.newNotificationWithOneButton("Error", message: "An error has occured, please try again later.", buttonMessage: "Okay")
                    
                }
            }
                //No errors -> email was sent
            else{
                _ = self.navigationController?.popViewController(animated: true)
                PopupModel.newNotificationWithOneButton("", message: "An email has been sent to \(self.emailField.text!) to reset your password.", buttonMessage: "Okay")
                
            }
            
        }

    }

}
