//
//  RatingViewController.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 10.07.17.
//
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var profilePhoto: UIImageView! {
        didSet {
            self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.width/2
            self.profilePhoto.layer.masksToBounds = true
            self.profilePhoto.clipsToBounds = true
            self.profilePhoto.layer.borderWidth = 2
            self.profilePhoto.layer.borderColor = UIColor.black.cgColor
            
        }
    }
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var saveRatingButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var headlineLabel: UILabel!

    
    var gameEntry: GameEntry? = nil
    
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    /* Erster Stern */
    var firstStarSelected = false
    @IBOutlet weak var firstStar: UIImageView! {
        didSet {
            self.firstStar.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.firstStarTapped))
            self.firstStar.addGestureRecognizer(gesture)
        }
    }
    
    func firstStarTapped() {
        if firstStarSelected {
            if secondStarSelected {
                secStarTapped()
            }
            if thirdStarSelected {
                thirdStarTapped()
            }
            if fourhStarSelected {
                fourthStarTapped()
            }
            if fivthStarSelected {
                fivthStarTapped()
            }
            firstStar.image = UIImage(named: "favourite-star")
        } else {
            firstStar.image = UIImage(named: "favourite-star-filled")
        }
        firstStarSelected = !firstStarSelected
    }
    
    
    /* Zweiter Stern */
    @IBOutlet weak var secondStar: UIImageView! {
        didSet {
            self.secondStar.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.secStarTapped))
            self.secondStar.addGestureRecognizer(gesture)
        }
    }
    
    var secondStarSelected = false
    func secStarTapped() {
        if secondStarSelected {
            if thirdStarSelected {
                thirdStarTapped()
            }
            if fourhStarSelected {
                fourthStarTapped()
            }
            if fivthStarSelected {
                fivthStarTapped()
            }
            secondStar.image = UIImage(named: "favourite-star")
        } else {
            if !firstStarSelected {
                firstStarTapped()
            }
            secondStar.image = UIImage(named: "favourite-star-filled")
        }
        secondStarSelected = !secondStarSelected
    }
    
    
    /* Dritter Stern */
    var thirdStarSelected = false
    @IBOutlet weak var thirdStar: UIImageView! {
        didSet {
            self.thirdStar.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.thirdStarTapped))
            self.thirdStar.addGestureRecognizer(gesture)
        }
    }
    func thirdStarTapped() {
        if thirdStarSelected {
            if fourhStarSelected {
                fourthStarTapped()
            }
            if fivthStarSelected {
                fivthStarTapped()
            }
            thirdStar.image = UIImage(named: "favourite-star")
        } else {
            if !firstStarSelected {
                firstStarTapped()
            }
            if !secondStarSelected {
                secStarTapped()
            }
            thirdStar.image = UIImage(named: "favourite-star-filled")
        }
        thirdStarSelected = !thirdStarSelected
    }
    
    /* Vierter Stern */
    var fourhStarSelected = false
    @IBOutlet weak var fourthStar: UIImageView! {
        didSet {
            self.fourthStar.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.fourthStarTapped))
            self.fourthStar.addGestureRecognizer(gesture)
        }
    }
    func fourthStarTapped() {
        if fourhStarSelected {
            if fivthStarSelected {
                fivthStarTapped()
            }
            fourthStar.image = UIImage(named: "favourite-star")
        } else {
            if !firstStarSelected {
                firstStarTapped()
            }
            if !secondStarSelected {
                secStarTapped()
            }
            if !thirdStarSelected {
                thirdStarTapped()
            }
            fourthStar.image = UIImage(named: "favourite-star-filled")
        }
        fourhStarSelected = !fourhStarSelected
    }
    
    /* Fünfter Stern */
    var fivthStarSelected = false
    @IBOutlet weak var fivthStar: UIImageView! {
        didSet {
            self.fivthStar.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.fivthStarTapped))
            self.fivthStar.addGestureRecognizer(gesture)
        }
    }
    
    func fivthStarTapped() {
        if fivthStarSelected {
            fivthStar.image = UIImage(named: "favourite-star")
        } else {
            if !firstStarSelected {
                firstStarTapped()
            }
            if !secondStarSelected {
                secStarTapped()
            }
            if !thirdStarSelected {
                thirdStarTapped()
            }
            if !fourhStarSelected {
                fourthStarTapped()
            }
            fivthStar.image = UIImage(named: "favourite-star-filled")
        }
        fivthStarSelected = !fivthStarSelected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = gameEntry!.ownerName
        NotificationCenter.default.addObserver(self, selector: #selector(self.setRatingInformation(_:)), name: NSNotification.Name(rawValue: "Rating"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setOwnRatingInformation), name: NSNotification.Name(rawValue: "OwnRating"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setProfilePhoto), name: NSNotification.Name(rawValue: "ProfilePhotoDownloaded"), object: nil)
        RatingModel.shared.getRatingsForUserId(userId: gameEntry!.owner)
        DBProvider.Instance.getUserProfilePhotoById(userId: gameEntry!.owner)

    }
    
    func setProfilePhoto(notification:Notification) {
        let url = notification.object as! URL
        profilePhoto.sd_setImage(with: url)
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
        } else if rating >= 1.5 && rating < 2.5 {
            starOne.image = UIImage(named:"favourite-star-filled")
            starTwo.image = UIImage(named:"favourite-star-filled")
        }else if rating >= 2.5 && rating < 3.5 {
            starOne.image = UIImage(named:"favourite-star-filled")
            starTwo.image = UIImage(named:"favourite-star-filled")
            starThree.image = UIImage(named:"favourite-star-filled")
        }else if rating >= 3.5 && rating < 4.5 {
            starOne.image = UIImage(named:"favourite-star-filled")
            starTwo.image = UIImage(named:"favourite-star-filled")
            starThree.image = UIImage(named:"favourite-star-filled")
            starFour.image = UIImage(named:"favourite-star-filled")
        } else if rating >= 4.5 {
            starOne.image = UIImage(named:"favourite-star-filled")
            starTwo.image = UIImage(named:"favourite-star-filled")
            starThree.image = UIImage(named:"favourite-star-filled")
            starFour.image = UIImage(named:"favourite-star-filled")
            starFive.image = UIImage(named:"favourite-star-filled")
        }
        
    }
    
    func setOwnRatingInformation(notification: NSNotification) {
        let entry = notification.object as! RatingEntry
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = Date(timeIntervalSince1970: Double(entry.created)!)
        let dateString = formatter.string(from: date)
        headlineLabel.text = "Your rating from \(dateString)"
        
        print(entry.rating)
        switch entry.rating {
        case 1:
            if !firstStarSelected {
                firstStarTapped()
            }
        case 2:
            if !secondStarSelected {
                secStarTapped()
            }
        case 3:
            if !thirdStarSelected {
                thirdStarTapped()
            }
        case 4:
            if !fourhStarSelected {
                fourthStarTapped()
            }
        case 5:
            if !fivthStarSelected {
                fivthStarTapped()
            }
        default:
            break
        }
        
        descriptionTextView.text = entry.descriptionText
        
        saveRatingButton.setTitle("Update", for: .normal)
    }

    @IBAction func saveRating(_ sender: Any) {
        var rating = 0
        if fivthStarSelected {
            rating = 5
        } else if fourhStarSelected {
            rating = 4
        } else if thirdStarSelected {
            rating = 3
        } else if secondStarSelected {
            rating = 2
        } else if firstStarSelected {
            rating = 1
        }
        
        let entry = RatingEntry.init(rating: rating, creator: CurrentUser.instance.getID(), name: CurrentUser.instance.userName, user: gameEntry!.owner, description: descriptionTextView.text)
        RatingModel.shared.saveEntryToDatabase(ratingEntry: entry)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
