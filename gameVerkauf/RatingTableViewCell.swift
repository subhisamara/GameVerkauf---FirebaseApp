//
//  RatingTableViewCell.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 12.07.17.
//
//

import UIKit

class RatingTableViewCell: UITableViewCell {

    var ratingEntry:RatingEntry? = nil
    
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setEntry(entry: RatingEntry) {
        self.ratingEntry = entry
        switch entry.rating {
        case 1:
            starOne.image = UIImage(named: "favourite-star-filled")
        case 2:
            starOne.image = UIImage(named: "favourite-star-filled")
            starTwo.image = UIImage(named: "favourite-star-filled")
        case 3:
            starOne.image = UIImage(named: "favourite-star-filled")
            starTwo.image = UIImage(named: "favourite-star-filled")
            starThree.image = UIImage(named: "favourite-star-filled")
        case 4:
            starOne.image = UIImage(named: "favourite-star-filled")
            starTwo.image = UIImage(named: "favourite-star-filled")
            starThree.image = UIImage(named: "favourite-star-filled")
            starFour.image = UIImage(named: "favourite-star-filled")
        case 5:
            starOne.image = UIImage(named: "favourite-star-filled")
            starTwo.image = UIImage(named: "favourite-star-filled")
            starThree.image = UIImage(named: "favourite-star-filled")
            starFour.image = UIImage(named: "favourite-star-filled")
            starFive.image = UIImage(named: "favourite-star-filled")
        default:
            break
        }
        
        headline.text = "Rating from \(entry.creatorName)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = Date(timeIntervalSince1970: Double(entry.created)!)
        let dateString = formatter.string(from: date)
        dateLabel.text = "\(dateString)"
        
        descriptionLabel.text = entry.descriptionText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
