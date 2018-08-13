//
//  OldEntryTableViewController.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 16.06.17.
//
//

import UIKit
class OldEntryTableViewController{
    /*
    
    //TEST ONLY
    var entries = [GameEntry(name: "Test", genre: GenreType.Action, console: ConsoleType.N64, price: 3.50, type: EntryType.SALE, image: UIImage(), description: "No description", owner: "1", date: Date()]
    
    var selectedIndex:IndexPath?
    var isExpanded = false

    func didExpandCell(){
        self.isExpanded = !isExpanded
        self.tableView.reloadRows(at: [selectedIndex!], with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.didExpandCell()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EntryTableViewCell
        let item = self.entries[indexPath.row]
        
        cell.entryName.text = item.name
        cell.entryConsole.text = item.console.rawValue
        
        cell.entrySeller.text = item.owner
        cell.genreLabel.text = item.genre.rawValue
        cell.entryImage.image = item.image
        //cell.entryImage.sizeToFit()
        
        //Price display
        
        let formattedFloat =  NSString(format: "%.2f€", item.price) as String
        switch(item.type){
        case EntryType.SALE:
            cell.entryPrice.text = formattedFloat
        case EntryType.TRADE:
            cell.entryPrice.text = "Trade"
        case EntryType.SALE_OR_TRADE:
            cell.entryPrice.text = "Trade or \(formattedFloat)"
        }
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (isExpanded && self.selectedIndex == indexPath){
            return 425
        }
        
        return 45
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "EntryTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadYTLinkViewController(_:)), name: Notification.Name(rawValue: "YouTubeLoad"), object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "YouTubeLoad"), object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadYTLinkViewController(_ notification: NSNotification) {
        DispatchQueue.main.sync{
            let sb: UIStoryboard = UIStoryboard(name : "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ytdisplay") as! YTLinkViewController
            vc.videoID = notification.object as? String
            self.present(vc, animated: true, completion: nil)
            
        }
    }
 */
}
