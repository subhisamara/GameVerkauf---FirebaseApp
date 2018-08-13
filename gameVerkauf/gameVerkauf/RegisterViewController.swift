//
//  RegisterViewController.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 03.06.17.
//
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth


@IBDesignable
class RegisterViewController: UIViewController {

    @IBOutlet weak var mailAdress: SkyFloatingLabelTextField!
    
    @IBOutlet weak var password: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordControll: SkyFloatingLabelTextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBInspectable var activeColorCorrect: UIColor = UIColor.blue
    @IBInspectable var activeColorFalse: UIColor = UIColor.red
    
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        if checkAllRegisterValues() {
            let email = self.mailAdress.text!
            let password = self.password.text!
            let username = self.usernameTextField.text!
            
            self.view.endEditing(true)
            LoginModule.shared.createUserWith(email: email, password: password, username: username)
        
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = self.mailAdress.text{
            if let floatingLabelTextField = self.mailAdress{
                let a = text.characters.count < 5 && !text.contains("@") || !text.contains(".")
                if(text.characters.count < 4 || a){
                    floatingLabelTextField.errorMessage = "Invalid email"
                } else{
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        
        if let text1 = self.password.text{
            if let floatingLabelTextField = self.password{
                if(text1.characters.count < 7){
                    floatingLabelTextField.errorMessage = "invalid password"
                } else{
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        
        if let text2 = self.passwordControll.text{
            if let floatingLabelTextField = self.passwordControll{
                if(text2 != password.text){
                    floatingLabelTextField.errorMessage = "password does not match"
                } else{
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        regDes()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .portrait)
    }
    
    func regDes(){
        self.registerButton.layer.borderWidth = 2.0;
        self.registerButton.layer.borderColor = UIColor (colorLiteralRed: 0, green: 255, blue: 255, alpha: 1).cgColor
        registerButton.layer.cornerRadius = 25
        mailAdress.autocorrectionType = .no
        mailAdress.becomeFirstResponder()
        usernameTextField.autocorrectionType = .no
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkAllRegisterValues() -> Bool {
        if let usernameEingabe = usernameTextField.text {
            if usernameEingabe == "" {
            PopupModel.newNotificationWithOneButton("Error", message: "Please enter a username", buttonMessage: "Okay")
            return false
            }
        } else {
            return false
        }
        if let mailAdresseEingabe = mailAdress.text {
            if mailAdresseEingabe == "" {
                PopupModel.newNotificationWithOneButton("Error", message: "Please enter a correct email address", buttonMessage: "Okay")
                return false
            }
        } else {
            return false
        }
        if let passwordEingabe = password.text {
            if passwordEingabe == ""  {
                PopupModel.newNotificationWithOneButton("Error", message: "Please enter a password", buttonMessage: "Okay")
                return false
            }
        } else {
            return false
        }
        
        if let passwordConfirm = passwordControll.text {
            if passwordConfirm == "" {
                PopupModel.newNotificationWithOneButton("Error", message: "Please confirm your password", buttonMessage: "Okay")
                return false
            }
            else if passwordConfirm != password.text {
                PopupModel.newNotificationWithOneButton("Error", message: "Passwords do not match", buttonMessage: "Try again")
                return false
            }
        } else {
            return false
        }
        
        
        
        return true
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
