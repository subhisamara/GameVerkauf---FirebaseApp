//
//  EntryTableViewCell.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 16.06.17.
//
//

import UIKit


class OldEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var entryName: UILabel!
    @IBOutlet weak var entryConsole: UILabel!
    @IBOutlet weak var entryPrice: UILabel!
    @IBOutlet weak var entryImage: UIImageView!
    @IBOutlet weak var entrySeller: UILabel!
    @IBOutlet weak var entryDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func trailerButtonClicked(_ sender: Any) {
        YTFetcher.shared.getRequest(name: entryName.text!, console: entryConsole.text!, type: .Trailer)
    }
    
    @IBAction func gameplayButtonClicked(_ sender: Any) {
        YTFetcher.shared.getRequest(name: entryName.text!, console: entryConsole.text!, type: .Gameplay)
        
    }
    
    
}
