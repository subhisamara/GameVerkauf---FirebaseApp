//
//  EntryTableViewCell.swift
//  gameVerkauf
//
//  Created by admin on 16.06.17.
//
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryName: UILabel!
    @IBOutlet weak var entryConsole: UILabel!
    @IBOutlet weak var entryPrice: UILabel!
    @IBOutlet weak var entryImage: UIImageView! {
        didSet {
            entryImage.layer.masksToBounds = true
            entryImage.layer.cornerRadius = 4
            entryImage.layer.borderWidth = 1
            entryImage.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var entrySeller: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var entryDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
