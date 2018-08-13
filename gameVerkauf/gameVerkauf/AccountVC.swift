import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseStorage
import MobileCoreServices
import SkyFloatingLabelTextField
import FBSDKLoginKit


class AccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profilePic: UIImageView!
    
    var user = FIRAuth.auth()?.currentUser
    let picker = UIImagePickerController()
    

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // which mean you are forced to use portrait.
        AppUtility.lockOrientation(.portrait)
        RatingModel.shared.getRatingsForUserId(userId: CurrentUser.instance.getID())
        profilePicDesign()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .portrait)
    }
    
    func setRatingInformation(_ notification: NSNotification) {
        let ratingEntries = notification.object as! [RatingEntry]
        var ratingStars = 0
        for rating in ratingEntries {
            ratingStars += rating.rating
        }
        let rating = Double(ratingStars)/Double(ratingEntries.count)
        if rating > 0.5 && rating < 1.5 {
            starOne.image = UIImage(named: "favourite-star-filled")
            starTwo.image = UIImage(named:"favourite-star")
            starThree.image = UIImage(named:"favourite-star")
            starFour.image = UIImage(named:"favourite-star")
            starFive.image = UIImage(named:"favourite-star")
        } else if rating >= 1.5 && rating < 2.5 {
            starOne.image = UIImage(named:"favourite-star-filled")
            starTwo.image = UIImage(named:"favourite-star-filled")
            starThree.image = UIImage(named:"favourite-star")
            starFour.image = UIImage(named:"favourite-star")
            starFive.image = UIImage(named:"favourite-star")
        }else if rating >= 2.5 && rating < 3.5 {
            starOne.image = UIImage(named:"favourite-star-filled")
            starTwo.image = UIImage(named:"favourite-star-filled")
            starThree.image = UIImage(named:"favourite-star-filled")
            starFour.image = UIImage(named:"favourite-star")
            starFive.image = UIImage(named:"favourite-star")
        }else if rating >= 3.5 && rating < 4.5 {
            starOne.image = UIImage(named:"favourite-star-filled")
            starTwo.image = UIImage(named:"favourite-star-filled")
            starThree.image = UIImage(named:"favourite-star-filled")
            starFour.image = UIImage(named:"favourite-star-filled")
            starFive.image = UIImage(named:"favourite-star")
        } else if rating >= 4.5 {
            starOne.image = UIImage(named:"favourite-star-filled")
            starTwo.image = UIImage(named:"favourite-star-filled")
            starThree.image = UIImage(named:"favourite-star-filled")
            starFour.image = UIImage(named:"favourite-star-filled")
            starFive.image = UIImage(named:"favourite-star-filled")
        }
    }

    
    func assignbackground(){
        let background = UIImage(named: "Background.png")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    
    func loadBackground(){
        if(UIApplication.shared.statusBarOrientation.isPortrait){
            let bgImage      = UIImage(named: "Background.png")
            let background   = UIImageView(frame: self.view.bounds);
            background.image = bgImage
            self.view.addSubview(background)
            self.view.sendSubview(toBack: background)
        } else {
            let bgImage      = UIImage(named: "WorldBG.png")
            let background   = UIImageView(frame: self.view.bounds);
            background.image = bgImage
            self.view.addSubview(background)
            self.view.sendSubview(toBack: background)
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        loadBackground()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBackground()
        //self.title = "Account"
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            NotificationCenter.default.addObserver(self, selector: #selector(self.setRatingInformation(_:)), name: NSNotification.Name(rawValue: "Rating"), object: nil)
        details()
    }
    
    @IBAction func items(_ sender: Any) {
        performSegue(withIdentifier: "goitems", sender: nil)
    }
     
    private func profilePicDesign(){
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.layer.masksToBounds = true
        self.profilePic.clipsToBounds = true
        self.profilePic.layer.borderWidth = 2
        self.profilePic.layer.borderColor = UIColor(red: 0, green: 255, blue: 255, alpha: 1.0).cgColor
        profilePic.image = CurrentUser.instance.userImage
    }
    
    private func details(){
        DBProvider.Instance.userRef.observe(.value, with: { (snapshot) in
            if let info = snapshot.value as? NSDictionary{
                if let username = info[Constants.USERNAME]{
                    self.name.text = username  as? String
                }
                if let number = info["call_number"] {
                    self.number.text = number as? String
                }
            }
        })
        self.email.text = FIRAuth.auth()?.currentUser?.email
    }
    
    
    
    @IBAction func edit(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Change", preferredStyle: .actionSheet)
       
        let changeEmailAction = UIAlertAction(title: "Email", style: .default, handler: self.handleChangeEmail)
        let changePassAction = UIAlertAction(title: "Password", style: .default, handler: self.handleChangePassword)
        let changeNumberAction = UIAlertAction(title: "Number", style: .default, handler: self.handleChangePhone)
        let changePhotoAction = UIAlertAction(title: "Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.choosePhoto(type: kUTTypeImage)
            })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let deleteAccountAction = UIAlertAction(title: "Delete Account", style: .default, handler: self.handleDeleteAccount)
        
        optionMenu.addAction(changeEmailAction)
        optionMenu.addAction(changePassAction)
        optionMenu.addAction(changeNumberAction)
        optionMenu.addAction(changePhotoAction)
        optionMenu.addAction(deleteAccountAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func deletion(id:String){
        DBProvider.Instance.usersRef.child(id).setValue(nil)
        DBProvider.Instance.dbRef.child("rating").child(id).setValue(nil)
        DBProvider.Instance.dbRef.child("entries").child(id).setValue(nil)
        DBProvider.Instance.storageRef.child("profilePhotos/" + id + "-profile.png").delete{ (err) in
            print("Photo does not excist")
        }
        DBProvider.Instance.usersRef.observe(.value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let current = rest.key as String
                DBProvider.Instance.usersRef.child(current).child("Contacts").child(id).setValue(nil)
                print("Messages: " + rest.key)
            }
        })
        DBProvider.Instance.dbRef.child("rating").observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let current = rest.key as String
                DBProvider.Instance.dbRef.child("rating").child(current).child(id).setValue(nil)
                print("rating: " + rest.key)
            }
        })

    }
    
    func handleDeleteAccount(alertAction: UIAlertAction!) -> Void {
        
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
            let id = (self.user?.uid)!
            self.deletion(id: id)
            self.user?.delete { error in
                if let error = error {
                    print(error.localizedDescription)
                    let alert = UIAlertController(title: "Delete not Successful", message: error.localizedDescription, preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(vc, animated: false, completion: nil)
                }
            }
            
        })
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addAction(submitAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleChangePassword(alertAction: UIAlertAction!) -> Void {
        let alert = UIAlertController(title: "Change Pass", message: "", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Change", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0]
            let textField2 = alert.textFields![1]

            if let text2 = textField2.text{
                if let text1 = textField.text{
                    if text1 == text2{
                    if textField.text != nil{
                        if(text1.characters.count < 7){
                            PopupModel.newNotificationWithOneButton("Error", message: "Password length must be greater than 8 characters", buttonMessage: "Okay")
                        }else{
                            self.user?.updatePassword(textField.text!)
                        }
                    }
                    }else{
                        PopupModel.newNotificationWithOneButton("Error", message: "Passwords do not match", buttonMessage: "Okay")
                    }
                }
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Insert your new password"
            textField.clearButtonMode = .whileEditing
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Confirm your new password"
            textField.clearButtonMode = .whileEditing
            textField.isSecureTextEntry = true
        }

        alert.addAction(submitAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func handleChangeEmail(alertAction: UIAlertAction!) -> Void {
        let alert = UIAlertController(title: "Change Email", message: "", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Change", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0]
            
            if let text = textField.text{
                if textField.text != nil{
                    let a = text.characters.count < 5 && !text.contains("@") || !text.contains(".")
                    if(text.characters.count < 4 || a){
                                    } else{
                        self.email.text=textField.text!
                        DBProvider.Instance.userEmailRef.setValue(textField.text!)
                        self.user?.updateEmail(textField.text!)
                    }
                }
            }
            })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addTextField { (textField: UITextField)  in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Insert your new Email"
            textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleChangePhone(alertAction: UIAlertAction!) -> Void {
        let alert = UIAlertController(title: "Change Phone Number", message: "", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Change", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0]
            self.number.text=textField.text!
            DBProvider.Instance.userRef.child("call_number").setValue(textField.text!)
        })


        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addTextField { (textField: UITextField)  in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .numberPad
            textField.autocorrectionType = .default
            textField.placeholder = "Insert your new phone number"
            textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func choosePhoto(type: CFString){
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            CurrentUser.instance.setNewUserImage(image: image)
            self.profilePic.image = Util.imageWithSize(image: image, size: CGSize(width: 200, height: 200))
        }
        self.dismiss(animated: true, completion: nil)
    }
   

    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginView") as! UINavigationController
        self.present(vc, animated: false, completion: nil)
    }
    
   }
