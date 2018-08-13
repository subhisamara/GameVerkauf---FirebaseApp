//
//  FilterTableViewCell.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 28.06.17.
//
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    var checked: Bool?
    
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterCheckButton: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
}
