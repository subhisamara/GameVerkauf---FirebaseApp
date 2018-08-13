//
//  MyItems.swift
//  gameVerkauf
//
//  Created by Subhi M. Samara on 13.07.17.
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MyItems: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var user = FIRAuth.auth()?.currentUser
    
    @IBOutlet weak var entryTableView: UITableView!
    var entries:[GameEntry] = []
    var selectedIndex: IndexPath?
    var deleteIndexPath: IndexPath? = nil
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .portrait)
    }

    override func viewDidLoad() {
        
        EntryModel.shared.getMyEntries()
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.setEntries), name: NSNotification.Name(rawValue: "getMyEntries"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: "reloadEntriesData"), object: nil)
        
        let nib = UINib.init(nibName: "EntryTableViewCell", bundle: nil)
        self.entryTableView.delegate = self
        self.entryTableView.dataSource = self
        self.entryTableView.register(nib, forCellReuseIdentifier: "cell")
        self.entryTableView.allowsMultipleSelectionDuringEditing = true
        
        let backgroundImage = UIImage(named: "Background.png")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        self.entryTableView.backgroundView = imageView
        self.entryTableView.backgroundView?.contentMode = .scaleToFill
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //tableview shit
    func setEntries(notification: NSNotification) {
        self.entries = notification.object as! [GameEntry]
        self.entries.sort { $0.date > $1.date}
        entryTableView.reloadData()
    }
    
    func reloadData(notification: NSNotification){
        entryTableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EntryTableViewCell
        let item = self.entries[indexPath.row]
        
        cell.entryName.text = item.name
        cell.entryConsole.text = item.console.rawValue
        cell.entrySeller.text = item.ownerName
        cell.genreLabel.text = item.genre.rawValue
        
        if let url = item.url {
            cell.entryImage.sd_setImage(with: url)
        } else {
            cell.entryImage.image = item.image
        }
        cell.entryImage.sizeToFit()
        
        //Price display
        
        let formattedFloat =  NSString(format: "%.2f €", item.price) as String
        switch(item.type){
        case EntryType.SALE:
            cell.entryPrice.text = formattedFloat
        case EntryType.TRADE:
            cell.entryPrice.text = "Trade"
        case EntryType.SALE_OR_TRADE:
            cell.entryPrice.text = "Trade or \(formattedFloat)"
        }
        
        //Date display
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        cell.entryDate.text = formatter.string(from: item.date as Date)
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    //delete on swipe
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entryToDelete = entries[indexPath.row]
            deleteIndexPath = indexPath
            confirmDelete(entry: entryToDelete)
        }
    }
    
    func confirmDelete(entry: GameEntry) {
        let alert = UIAlertController(title:  "Delete entry", message: "Are you sure you want to delete \(entry.name)?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: confirmedDeleteEntry)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteEntry)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func confirmedDeleteEntry(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteIndexPath {
            
            let entryToDelete = self.entries[indexPath.row]
            var entryIdToDelete : String?
            let reference = DBProvider.Instance.dbRef
            let ref = reference.child("entries").child(Constants.CURRENTUSER_ID!)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                
                if !snapshot.exists() { return }
                
                
                for snap in snapshot.children {
                    let entry = (snap as! FIRDataSnapshot).value as! NSDictionary
                    
                    //compare by date
                    if(entryToDelete.date == Date(timeIntervalSince1970: Double(entry["date"] as! String)!)){
                        entryIdToDelete = (snap as! FIRDataSnapshot).key
                    }
                }
                if let entryId = entryIdToDelete {
                    ref.child(entryId).removeValue()
                }
            })
            
            entryTableView.beginUpdates()
            entries.remove(at: indexPath.row)
            entryTableView.deleteRows(at: [indexPath], with: .automatic)
            deleteIndexPath = nil
            entryTableView.endUpdates()
            entryTableView.reloadData()
        }
    }
    
    func cancelDeleteEntry(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        performSegue(withIdentifier: "myDetailView", sender: self.entries[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myDetailView" {
            let vc = segue.destination as! DetailViewController
            vc.set(gameEntry: sender as! GameEntry)
        }
    }

}
