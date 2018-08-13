//
//  InsertionViewController.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 20.06.17.
//
//

import UIKit
import Fusuma

class InsertionViewController: UIViewController, UINavigationControllerDelegate, FusumaDelegate, UITextViewDelegate {

    
    // MARK : - Instanzvariablen
    
    var selectedPlatform: ConsoleType? = nil
    var selectedGenre: GenreType? = nil
    var selectedImage: UIImage? = nil
    var tradeCheckboxChecked = false
    var sellCheckboxChecked = false
    
    let lightGray:UIColor = UIColor.lightGray
    let successColor:UIColor = UIColor(red:0.00, green:0.80, blue:0.40, alpha:1.0)
    
    @IBOutlet weak var platformButton: UIButton! {
        didSet {
            self.platformButton.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var genreButton: UIButton! {
        didSet{
            self.genreButton.layer.cornerRadius = 5
        }
    }
    
    
    // MARK : - @IBOutlet
    @IBAction func resetButtonPressed(_ sender: Any) {
        self.resetUserEntries()
    }
    @IBOutlet weak var pictureButton: UIButton!
    
    @IBAction func picutreButtonAdded(_ sender: Any) {
        pictureImageViewPressed()
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            self.scrollView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.keyboardDismiss))
            self.scrollView.addGestureRecognizer(gesture)
        }
    }
    
    @IBOutlet weak var headlineLabel: UILabel!

    @IBOutlet weak var platformLabel: UILabel! {
        didSet {
            platformLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var genreLabel: UILabel! {
        didSet {
            genreLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var priceTextField: UITextField!{
        didSet {
            priceTextField.isEnabled = true
        }
    }
    
    @IBOutlet weak var sellCheckbox: UIImageView! {
        didSet {
            self.sellCheckbox.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.sellCheckboxPressed (_:)))
            self.sellCheckbox.addGestureRecognizer(gesture)
        }
    }
    
    @IBOutlet weak var tradeCheckbox: UIImageView! {
        didSet {
            self.tradeCheckbox.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tradeCheckboxPressed (_:)))
            self.tradeCheckbox.addGestureRecognizer(gesture)
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.delegate = self
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (scrollView.contentOffset.y < 307) {
            scrollView.contentOffset.y += 170
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (scrollView.contentOffset.y > 307) {
            scrollView.contentOffset.y -= 170
        }
    }
    
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.layer.cornerRadius = 5
            sendButton.layer.shadowOffset = CGSize(width: 4, height: 4)
            sendButton.layer.shadowColor = UIColor.black.cgColor
            sendButton.layer.shadowOpacity = 0.3
            sendButton.layer.shadowRadius = 5
        }
    }
    
    @IBAction func genrePickerButtonPressed(_ sender: Any) {
        let nib = UINib(nibName: "GenrePicker", bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first! as! GenreSelectionView
        
        let viewPoint = CGPoint(x: 0, y: self.view.frame.midY/2)
        nibView.frame = CGRect(origin: viewPoint, size: CGSize(width: self.view.frame.width, height: nibView.frame.height))
        
        self.view.addSubview(nibView)
        nibView.bringSubview(toFront: self.view)
    }
    
    @IBAction func pickPlatformButtonPressed(_ sender: Any) {
        let nib = UINib(nibName: "Picker", bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first! as! PlatformSelectionView
        
        let viewPoint = CGPoint(x: 0, y: self.view.frame.midY/2)
        nibView.frame = CGRect(origin: viewPoint, size: CGSize(width: self.view.frame.width, height: nibView.frame.height))
        
        self.view.addSubview(nibView)
        nibView.bringSubview(toFront: self.view)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        keyboardDismiss()
        let price: Float = priceTextField.text!.floatValue
        if let name = nameTextField.text, let platform = self.selectedPlatform, let genre = self.selectedGenre, let image = selectedImage, let description = self.descriptionTextView.text, (sellCheckboxChecked || tradeCheckboxChecked) {
            var type: EntryType? = nil
            
            if sellCheckboxChecked {
                type = EntryType.SALE
            } else if tradeCheckboxChecked {
                type = EntryType.TRADE
            }
            
            if sellCheckboxChecked && tradeCheckboxChecked {
                type = EntryType.SALE_OR_TRADE
            }
            let userName = CurrentUser.instance.userName
            let entry = GameEntry(name: name, genre: genre, console: platform, price: price,type: type!, image: image, description: description, owner: CurrentUser.instance.getID(),ownerName: userName, date: Date())
            PopupModel.shared.startActivityIndicator(text: "Uploading", width: 100, height: 100)
            EntryModel.shared.saveEntryToDatabase(gameEntry: entry)
            
            
        } else {
            PopupModel.newNotificationWithOneButton("Error", message: "Please fill out all required fields and make sure you have selected an image.", buttonMessage: "Okay")
        }
    }
    
    //5 Second delay with popup message : successful uploading
    func successPopup(){
        let alert = UIAlertController(title: "", message: "Your entry has been successfully uploaded.", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 4
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                self.tabBarController?.selectedIndex = 0
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.platformPicked), name: NSNotification.Name(rawValue: "PlatformPicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.genrePicked), name: NSNotification.Name(rawValue: "GenrePicked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.entrySaved), name: NSNotification.Name(rawValue: "SavedEntry"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.entrySavedError), name: NSNotification.Name(rawValue: "SavedEntryError"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setApiEntry), name: NSNotification.Name(rawValue: "GetApiEntry"), object: nil)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(Util.getImageWithColor(color: UIColor.groupTableViewBackground, size: CGSize(width: 1, height: 1)), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : - Private Funktionen
    
    func pictureImageViewPressed() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false
        fusuma.modeOrder = .cameraFirst
        fusumaTintColor = UIColor.black
        fusumaBackgroundColor = UIColor.groupTableViewBackground
        fusumaBaseTintColor = UIColor.darkGray
        
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func sellCheckboxPressed(_ sender: UITapGestureRecognizer) {
        if sellCheckboxChecked {
            self.sellCheckbox.image = UIImage(named: "checkbox-unchecked")
            self.priceTextField.text = ""
        } else {
            self.sellCheckbox.image = UIImage(named: "checkbox-checked")
            
        }
        self.sellCheckboxChecked = !self.sellCheckboxChecked
    }
    
    func tradeCheckboxPressed(_ sender: UITapGestureRecognizer) {
        if tradeCheckboxChecked {
            self.tradeCheckbox.image = UIImage(named: "checkbox-unchecked")
        } else {
            self.tradeCheckbox.image = UIImage(named: "checkbox-checked")
        }
        self.tradeCheckboxChecked = !self.tradeCheckboxChecked
    }
    
    func platformPicked(notification: NSNotification) {
        let platform = notification.object as! ConsoleType
        platformButton.setTitle(platform.rawValue, for: .normal)
        platformButton.backgroundColor = successColor
        //platformLabel.isHidden = false
        //platformLabel.text = platform.rawValue
        self.selectedPlatform = platform
        self.view.subviews.last!.removeFromSuperview()
    }
    
    func genrePicked(notification: NSNotification) {
        let platform = notification.object as! GenreType
        genreButton.setTitle(platform.rawValue, for: .normal)
        genreButton.backgroundColor = successColor
        //genreLabel.isHidden = false
        //genreLabel.text = platform.rawValue
        self.selectedGenre = platform
        self.view.subviews.last!.removeFromSuperview()
    }
    
    func entrySaved(notification: NSNotification) {
        PopupModel.shared.stopActivityIndicator()
        resetUserEntries()
        let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
        self.scrollView.setContentOffset(desiredOffset, animated: true)
        successPopup()
    }
    
    func entrySavedError(notification: NSNotification) {
        PopupModel.shared.stopActivityIndicator()
        let error = notification.object
        PopupModel.newNotificationWithOneButton("Error", message: error.debugDescription, buttonMessage: "Okay")
    }
    
    func resetUserEntries() {
        selectedImage = nil
        selectedGenre = nil
        selectedPlatform = nil
        tradeCheckboxChecked = false
        sellCheckboxChecked = false
        
        self.pictureButton.imageView!.image = UIImage(named: "addImage")
        self.nameTextField.text = ""
        self.platformButton.setTitle("Select a platform", for: .normal)
        self.platformButton.backgroundColor = lightGray
        self.genreButton.setTitle("Select a genre",  for: .normal)
        self.genreButton.backgroundColor = lightGray
        self.priceTextField.text = ""
        self.tradeCheckbox.image = UIImage(named: "checkbox-unchecked")
        self.sellCheckbox.image = UIImage(named: "checkbox-unchecked")
        self.descriptionTextView.text = ""
    }
    
    // MARK: - Keyboard Controlls
    @objc func keyboardDismiss() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,y: self.view.frame.origin.y, width: self.view.frame.width, height: viewHeight + keyboardSize.height)
        }
    }
    
    func imageWithSize(image: UIImage, size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth:CGFloat = size.width / image.size.width
        let aspectHeight:CGFloat = size.height / image.size.height
        let aspectRatio:CGFloat = max(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = image.size.width * aspectRatio
        scaledImageRect.size.height = image.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        image.draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    // MARK: - FusumaDelegate
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        self.selectedImage = image
        pictureButton.imageView!.image = self.imageWithSize(image: image, size: pictureButton.bounds.size)
        self.dismiss(animated: true, completion: nil)
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        print("Called just after FusumaViewController is dismissed.")
        self.selectedImage = image
        pictureButton.imageView!.image = self.imageWithSize(image: image, size: pictureButton.bounds.size)
        self.dismiss(animated: true, completion: nil)
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        PopupModel.newNotificationWithOneButton("Error", message: "To take pictures we need your authorization.", buttonMessage: "Okay")
    }
    
    func setApiEntry(notification: NSNotification) {
        resetUserEntries()
        let game = notification.object as! NSDictionary
        
        self.nameTextField.text = game["name"] as? String
        if let summary =  game["summary"] as? String {
            self.descriptionTextView.text = summary
        }
        
        if let genre = game["genres"] as? NSArray {
            if let genreInt = genre[0] as? Int {
                var genreType:GenreType? = nil
                switch genreInt {
                case 7:
                    genreType = GenreType.Music
                case 10:
                    genreType = GenreType.Racing
                case 11, 15, 16:
                    genreType = GenreType.Strategy
                case 12:
                    genreType = GenreType.RPG
                case 13:
                    genreType = GenreType.Simulation
                case 14:
                    genreType = GenreType.Sport
                case 25:
                    genreType = GenreType.BeatEmUp
                case 26:
                    genreType = GenreType.Quiz
                case 31:
                    genreType = GenreType.Adventure
                case 32:
                    genreType = GenreType.Indie
                case 33:
                    genreType = GenreType.Arcade
                case 4:
                    genreType = GenreType.Fighting
                case 5:
                    genreType = GenreType.Shooter
                case 9:
                    genreType = GenreType.Puzzle
                default:
                    genreType = GenreType.Other
                }
                
                NotificationsController.genrePickedNotification(type: genreType!)
                
            }
        }
        
        if let imgInfo = game["cover"] as? [String:Any] {
            if let imageId = imgInfo["cloudinary_id"] as? String {
                let url = URL(string: "https://images.igdb.com/igdb/image/upload/\(imageId).jpg")
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        if let downloadedImage = image {
                            self.selectedImage = downloadedImage
                            self.pictureButton.imageView!.image = self.imageWithSize(image: downloadedImage, size: self.pictureButton.bounds.size)
                        }
                    }
                }
                
            }
        }


    }
    

    
    // MARK: - Navigation


    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
