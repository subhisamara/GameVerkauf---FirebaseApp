//
//  DetailViewController.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 28.06.17.
//
//

import UIKit
import SwiftPhotoGallery
import SDWebImage
import FirebaseAuth


class DetailViewController: UIViewController, SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var consoleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView! {
        didSet {
            self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width/2
            self.profilePictureImageView.layer.masksToBounds = true
            self.profilePictureImageView.clipsToBounds = true
            self.profilePictureImageView.layer.borderWidth = 2
            self.profilePictureImageView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    @IBOutlet weak var trailerImageView: UIImageView! {
        didSet {
            self.trailerImageView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.trailerImageViewPressed (_:)))
            self.trailerImageView.addGestureRecognizer(gesture)
        }
    }
    
    @IBOutlet weak var screenshotImageView: UIImageView! {
        didSet {
            self.screenshotImageView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.screenshotViewPressed (_:)))
            self.screenshotImageView.addGestureRecognizer(gesture)
        }
    }
    @IBOutlet weak var reviewsImageView: UIImageView!{
        didSet {
            self.reviewsImageView.isUserInteractionEnabled = true
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.reviewsImageViewPressed(_:)))
            self.reviewsImageView.addGestureRecognizer(gesture)
        }
    }
    var gameEntry: GameEntry? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        CurrentContact.instance.ID = (self.gameEntry?.owner)!

        NotificationCenter.default.addObserver(self, selector: #selector(self.loadYTLinkViewController(_:)), name: Notification.Name(rawValue: "YouTubeLoad"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.youtubeError), name: Notification.Name(rawValue: "YouTubeError"), object: nil)
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.setRatingInformation(_:)), name: NSNotification.Name(rawValue: "Rating"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setProfilePhoto(_:)), name: NSNotification.Name(rawValue: "ProfilePhotoDownloaded"), object: nil)
    }

    func setProfilePhoto(_ notification:Notification) {
        let url = notification.object as! URL
        profilePictureImageView.sd_setImage(with: url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.headline.text = self.gameEntry!.name
        if let url = self.gameEntry!.url {
            self.imageView.sd_setImage(with: url)
        } else {
            self.imageView.image = self.gameEntry!.image
        }
        self.genreLabel.text = self.gameEntry!.genre.rawValue
        self.priceLabel.text = NSString(format: "%.2f €", self.gameEntry!.price) as String
        self.consoleLabel.text = self.gameEntry!.console.rawValue
        self.nameLabel.text = self.gameEntry!.ownerName
        self.descriptionLabel.text = self.gameEntry!.description
        
        if self.gameEntry!.owner == CurrentUser.instance.getID() {
            rateButton.isEnabled = false
            profilePictureImageView.image = CurrentUser.instance.userImage
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(Util.getImageWithColor(color: UIColor.groupTableViewBackground, size: CGSize(width: 1, height: 1)), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func set(gameEntry ge: GameEntry) {
        self.gameEntry = ge
        RatingModel.shared.getRatingsForUserId(userId: ge.owner)
        DBProvider.Instance.getUserProfilePhotoById(userId: ge.owner)
    }
    
    func trailerImageViewPressed(_ sender: UITapGestureRecognizer){
        YTFetcher.shared.getRequest(name: self.gameEntry!.name, console: self.gameEntry!.console.rawValue, type: .Gameplay)
        PopupModel.shared.startActivityIndicator(text: "Loading", width: 100, height: 100)
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
    
    var galleryImages:[UIImage] = []
    
    func screenshotViewPressed(_ sender: UITapGestureRecognizer) {
        if galleryImages.count == 0 {
        PopupModel.shared.startActivityIndicator(text: "Loading", width: 100, height: 100)
        let headers:[String:String] = ["X-Mashape-Key":"QaS6Hi2qXxmshTwZuE7XrnaLdomRp1GLQJhjsneovxomJqpfDT","Accept":"application/json"]
        
        var searchText:String = self.gameEntry!.name
        searchText = searchText.replacingOccurrences(of: " ", with: "+")
        var req = URLRequest(url: URL(string:"https://igdbcom-internet-game-database-v1.p.mashape.com/games/?fields=screenshots&limit=1&offset=0&search=\(searchText)")!)
        req.httpMethod = "GET"
        req.allHTTPHeaderFields = headers
            
            let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            var tableDataArray:[[String:Any]] = []
            guard error == nil else{
                print(error!)
                return
            }
            guard let data = data else{
                print ("Data is empty")
                return
            }
            
            let array = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
            //print(array)
            for elem in array! {
                tableDataArray.append(elem)
            }
            
            DispatchQueue.main.async{

                if let resultArray = tableDataArray.first?["screenshots"] as? Array<Dictionary<String,Any>> {
                
                    var resultCount = resultArray.count
                    for result in resultArray {
                        let pictureString = result["cloudinary_id"] as! String
                        
                        let url = URL(string: "https://images.igdb.com/igdb/image/upload/\(pictureString).jpg")!
                        
                        SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .continueInBackground, progress: nil , completed: { (image, data, error, finished) in
                            if error != nil {
                                print("Error . Probably .png File")
                                PopupModel.shared.stopActivityIndicator()
                                PopupModel.newNotificationWithOneButton("Error", message: "Error with picture fiels", buttonMessage: "Okay, nevermind!")
                                return
                            }
                            
                            if let downloadedPicture = image {
                                self.galleryImages.append(downloadedPicture)
                            } else {
                                resultCount -= 1
                            }
                            
                            if self.galleryImages.count == resultCount {
                                PopupModel.shared.stopActivityIndicator()
                                self.activateGallery()
                            }
                        })
                    }
                } else {
                    PopupModel.shared.stopActivityIndicator()
                    PopupModel.newNotificationWithOneButton("Error", message: "There are no screenshots avaiable for \(self.gameEntry!.name)", buttonMessage: "Okay")
                    
                }
            }
        }
        task.resume()
        } else {
            self.activateGallery()
        }
        
    }
    
    func reviewsImageViewPressed(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "reviewsView", sender: self)
    }
    
    func activateGallery() {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        self.present(gallery, animated: true, completion: {})
    }
    
    func loadYTLinkViewController(_ notification: NSNotification) {
        DispatchQueue.main.sync{
            PopupModel.shared.stopActivityIndicator()
            let sb: UIStoryboard = UIStoryboard(name : "Item", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ytdisplay") as! YTLinkViewController
            vc.videoID = notification.object as? String
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    func youtubeError() {
        PopupModel.shared.stopActivityIndicator()
        PopupModel.newNotificationWithOneButton("Error", message: "No YouTube video has been found for this entry.", buttonMessage: "Okay")
    }

    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return galleryImages.count
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return galleryImages[forIndex]
    }
    
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        // do something cool like:
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RatingViewController {
            vc.gameEntry = self.gameEntry!
        } else if let vc = segue.destination as? AllRatingsViewController {
            vc.setGameEntry(gameEntry: self.gameEntry!)
        } else if let vc = segue.destination as? ReviewViewController {
            vc.setGameEntry(gameEntry: self.gameEntry!)
        }
    }

    
    @IBAction func contact(_ sender: Any) {
        let alert = UIAlertController(title: "Make Contact" , message: "Would you like to contact " + (self.gameEntry?.ownerName)! + "?", preferredStyle: .actionSheet)
        let ChatAction = UIAlertAction(title: "Chat", style: .default, handler: self.handleChatContact)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ChatAction)
        alert.addAction(CancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect.init(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func handleChatContact(alertAction: UIAlertAction!) -> Void {
        DBProvider.Instance.userContactsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(CurrentContact.instance.ID){
                CurrentContact.instance.ID = (self.gameEntry?.owner)!
                let storyboard = UIStoryboard(name: "chat", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MessagesExchangeVC")
                self.navigationController?.pushViewController(vc, animated: true)
            } else{
                DBProvider.Instance.usersRef.child((self.gameEntry?.owner)!).observeSingleEvent(of: .value, with: { (snapshot1) in
                    if let userInformation = snapshot1.value as? NSDictionary {
                        let email = userInformation["User_Email"] as! String
                        DBProvider.Instance.saveContact(userID: (self.gameEntry?.owner)!, email: email)
                        DBProvider.Instance.saveContactMirror(userID: (self.gameEntry?.owner)!, email: (FIRAuth.auth()?.currentUser?.email)!)
                        
                        CurrentContact.instance.ID = (self.gameEntry?.owner)!
                        
                        let storyboard = UIStoryboard(name: "chat", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MessagesExchangeVC")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            }
        })
    
    }
    
    @IBAction func shareEntryPressed(_ sender: Any) {
        var text = ""
        if let url = gameEntry!.url {
            text = "Hey check out \(gameEntry!.name) for \(gameEntry!.console.rawValue) from \(gameEntry!.ownerName) on GamersZone. Picturelink: \(url)"
        } else {
            text = "Hey check out \(gameEntry!.name) for \(gameEntry!.console.rawValue) from \(gameEntry!.ownerName) on GamersZone."
        }
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
