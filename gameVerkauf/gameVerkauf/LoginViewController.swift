//
//  ViewController.swift
	//  gameVerkauf
//
//  Created by Fabian Frey on 24.05.17.
//  Copyright © 2017 Fabian Frey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
@IBDesignable
class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    @IBInspectable @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextInput: SkyFloatingLabelTextField!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var passwordTextInput: SkyFloatingLabelTextField!
    
    static var contact = ""
    static var id = ""
    
    var firebaseHandler:FIRAuthStateDidChangeListenerHandle? = nil
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        LoginModule.shared.checkLogin(email: emailTextInput.text!, password: passwordTextInput.text!)
        PopupModel.shared.startActivityIndicator(text: "", width: 150, height: 150)
    }
    
    @objc @IBAction func fbLoginButtonPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ReadPermission.publicProfile, ReadPermission.email], viewController: self) { (loginResult) in
            switch loginResult{
            case LoginResult.failed(let error):
                PopupModel.newNotificationWithOneButton("Error", message: "Login has failed: \(error.localizedDescription)", buttonMessage: "Okay")
            case LoginResult.cancelled:
                PopupModel.newNotificationWithOneButton("Error", message: "User has cancelled signing in", buttonMessage: "Okay")
            case LoginResult.success(let grantedPermissions ,let declinedPermissions, _):
                print("Logged in!")
                //data will be passed
                print("\(grantedPermissions)")
                print("\(declinedPermissions)")
                FBLoginModule.init().loginSuccess()
            }
        }
        
    }
    
    @IBAction func googleLoginButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = self.emailTextInput.text{
            if let floatingLabelTextField = self.emailTextInput{
                let a = text.characters.count < 5 && !text.contains("@") || !text.contains(".")
                if(text.characters.count < 4 || a){
                    floatingLabelTextField.errorMessage = "Invalid email"
                } else{
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        return true
    }
    
    
    
    func loginDesign() {
        self.loginButton.layer.borderWidth = 2.0;
        self.loginButton.layer.borderColor = UIColor (colorLiteralRed: 0, green: 255, blue: 255, alpha: 1).cgColor
        loginButton.layer.cornerRadius = 25
        
        self.registerButton.layer.borderWidth = 2.0;
        self.registerButton.layer.borderColor = UIColor (colorLiteralRed: 0, green: 255, blue: 255, alpha: 1).cgColor
        registerButton.layer.cornerRadius = 25
        
        self.emailTextInput.placeholder = "Email Address"
        self.emailTextInput.title = "Your Email"
        
        self.passwordTextInput.placeholder = "Password"
        self.passwordTextInput.title = "Your Password"
        
        
        
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginDesign()

        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addNotificationObservers()
        AppUtility.lockOrientation(.portrait)
    }
    
    internal func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishLogin(_:)), name: Notification.Name(rawValue: "UserLogin"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishLoginError(_:)), name: Notification.Name(rawValue: "UserLoginError"), object: nil)
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "UserLogin"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "UserLoginError"), object: nil)
        
        /*if let fireHandler = self.firebaseHandler {
            FIRAuth.auth()?.removeStateDidChangeListener(fireHandler)
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func finishLogin(_ notification: Notification) {
        performSegue(withIdentifier: "loginSegue", sender: nil)
        PopupModel.shared.stopActivityIndicator()
    }
    
    @objc func finishLoginError(_ notification: Notification) {
        PopupModel.shared.stopActivityIndicator()
        passwordTextInput.text = ""
        PopupModel.newNotificationWithOneButton("Error", message: "An error has occured while logging in", buttonMessage: "Okay")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .portrait)
    }
}

