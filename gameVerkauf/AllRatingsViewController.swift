//
//  AllRatingsViewController.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 12.07.17.
//
//

import UIKit

class AllRatingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 2
        self.profileImageView.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fivthStar: UIImageView!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var allRatings: UILabel!
    @IBOutlet weak var ratingNumber: UILabel!
    
    var entries : [RatingEntry] = []
    var gameEntry : GameEntry? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingTableView.dataSource = self
        ratingTableView.delegate = self
        ratingTableView.rowHeight = UITableViewAutomaticDimension
        ratingTableView.estimatedRowHeight = 200
        ratingTableView.backgroundView?.backgroundColor = UIColor.groupTableViewBackground
        
        let nib = UINib.init(nibName: "RatingTableViewCell", bundle: nil)
        self.ratingTableView.register(nib, forCellReuseIdentifier: "RatingCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setRatingInformation(_:)), name: NSNotification.Name(rawValue: "Rating"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let entry = self.gameEntry {
            nameLabel.text = entry.ownerName
            if entry.owner == CurrentUser.instance.getID() {
                profileImageView.image = CurrentUser.instance.userImage
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(self.setProfilePhoto), name: NSNotification.Name(rawValue: "ProfilePhotoDownloaded"), object: nil)
                DBProvider.Instance.getUserProfilePhotoById(userId: entry.owner)
            }
        }
        
    }
    
    func setProfilePhoto(notification:Notification) {
        let url = notification.object as! URL
        profileImageView.sd_setImage(with: url)
    }
    
    func setRatingInformation(_ notification: NSNotification) {
        let ratingEntries = notification.object as! [RatingEntry]
        self.entries = ratingEntries
        ratingTableView.reloadData()
        
        var ratingStars = 0
        for rating in ratingEntries {
            ratingStars += rating.rating
        }
        
        let rating = Double(ratingStars)/Double(ratingEntries.count)
        if rating > 0.5 && rating < 1.5 {
            firstStar.image = UIImage(named: "favourite-star-filled")
        } else if rating >= 1.5 && rating < 2.5 {
            firstStar.image = UIImage(named:"favourite-star-filled")
            secondStar.image = UIImage(named:"favourite-star-filled")
        }else if rating >= 2.5 && rating < 3.5 {
            firstStar.image = UIImage(named:"favourite-star-filled")
            secondStar.image = UIImage(named:"favourite-star-filled")
            thirdStar.image = UIImage(named:"favourite-star-filled")
        }else if rating >= 3.5 && rating < 4.5 {
            firstStar.image = UIImage(named:"favourite-star-filled")
            secondStar.image = UIImage(named:"favourite-star-filled")
            thirdStar.image = UIImage(named:"favourite-star-filled")
            fourthStar.image = UIImage(named:"favourite-star-filled")
        } else if rating >= 4.5 {
            firstStar.image = UIImage(named:"favourite-star-filled")
            secondStar.image = UIImage(named:"favourite-star-filled")
            thirdStar.image = UIImage(named:"favourite-star-filled")
            fourthStar.image = UIImage(named:"favourite-star-filled")
            fivthStar.image = UIImage(named:"favourite-star-filled")
        }
        
        allRatings.text = "(\(ratingEntries.count))"
        ratingNumber.text = "\(round(rating*100)/100)"
    }
    
    func setGameEntry(gameEntry: GameEntry) {
        self.gameEntry = gameEntry
        RatingModel.shared.getRatingsForUserId(userId: gameEntry.owner)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingTableViewCell
        
        cell.setEntry(entry: entries[indexPath.row])
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.groupTableViewBackground

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
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
