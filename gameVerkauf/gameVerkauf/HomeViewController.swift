//
//  HomeViewController.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 25.06.17.
//
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headlineLabel: UILabel!
    
    var entries:[GameEntry] = []
    var filteredEntries: [GameEntry]!
    
    var selectedIndex:IndexPath?
    
    override func viewDidLoad() {
        EntryModel.shared.getAllEntries()
        super.viewDidLoad()
        let nib = UINib.init(nibName: "EntryTableViewCell", bundle: nil)
        self.tableView.delegate = self
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setEntries), name: NSNotification.Name(rawValue: "getAllEntries"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: "reloadEntriesData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.filterData), name: NSNotification.Name(rawValue: "filterData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUserName), name: NSNotification.Name(rawValue: "UserName"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUsername), name: NSNotification.Name(rawValue: "NoUsername"), object: nil)
        
        self.filteredEntries = entries
        self.searchBar.scopeButtonTitles = ["Newest", "Alphabetical", "Price"]
        self.searchBar.showsScopeBar = true
        
        //to delete the annoying border at the top, blank image
        self.searchBar.backgroundImage = UIImage()
        
        //use bookmarks button as a custom button for filtering
        self.searchBar.showsBookmarkButton = true
        self.searchBar.setImage(UIImage(named: "filter.png"), for: .bookmark, state: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headlineLabel.text = "Hi \(CurrentUser.instance.userName)"
        filterData()
        sortByScope(selectedScope: searchBar.selectedScopeButtonIndex)
        tableView.reloadData()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setEntries(notification: NSNotification) {
        self.entries = notification.object as! [GameEntry]
        self.entries = entries.sorted{ $0.date > $1.date }
        self.filteredEntries = self.entries
        tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        performSegue(withIdentifier: "detailView", sender: self.filteredEntries[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            let vc = segue.destination as! DetailViewController
            vc.set(gameEntry: sender as! GameEntry)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EntryTableViewCell
        let item = self.filteredEntries[indexPath.row]
        
        cell.entryName.text = item.name
        cell.entryConsole.text = item.console.rawValue
        cell.entrySeller.text = item.ownerName
        cell.genreLabel.text = item.genre.rawValue
        //Image
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
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredEntries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    //updates filtered data based on the text in the search box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText == "") {
            filteredEntries = entries
           
        }
            
        else {
        
            filteredEntries = entries.filter{
            ($0.name.range(of: searchText, options: .caseInsensitive) != nil) || ($0.console.rawValue.range(of: searchText, options: .caseInsensitive) != nil) || ($0.description.range(of: searchText, options: .caseInsensitive) != nil) || ($0.ownerName.range(of: searchText, options: .caseInsensitive) != nil)
            }
            
           
        }
        
        self.sortByScope(selectedScope: searchBar.selectedScopeButtonIndex)        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.searchBar.endEditing(true)
        sortByScope(selectedScope: selectedScope)
    }
    
    func sortByScope(selectedScope: Int){
        var sortedEntries: [GameEntry]
        switch(selectedScope) {
        case 0:
            sortedEntries = filteredEntries.sorted(by: {$0.date > $1.date})
            self.entries = self.entries.sorted(by: {$0.date > $1.date})
        case 1:
            sortedEntries = filteredEntries.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})
            self.entries = self.entries.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})
        case 2:
            sortedEntries = filteredEntries.sorted(by: {$0.price < $1.price})
            self.entries = self.entries.sorted(by: {$0.price < $1.price})
        default:
            sortedEntries = filteredEntries
        }
        filteredEntries = sortedEntries
        self.tableView.reloadData()
    
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "filterViewSegue", sender: nil)
    }
    
    func filterData(){
        let arrayObject = FilterObject.shared
        
        let entryArray = arrayObject.types
        let consoleArray = arrayObject.consoles
        let genreArray = arrayObject.genres
    
        var epicFilter = entries
        
        epicFilter = epicFilter.filter{
            entryArray.contains($0.type) && consoleArray.contains($0.console) && genreArray.contains($0.genre)
        }
        self.filteredEntries = epicFilter
        self.tableView.reloadData()
    }
    
    func setUserName() {
        headlineLabel.text = "Hi \(CurrentUser.instance.userName)"
    }
    
    func getUsername() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "We need your username", message: "Enter a username", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "username"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            let username = textField.text!
            
            if (username != "") {
                //when user has disabled showing email
                var email: String = "No email"
                if CurrentUser.instance.getEmail() != nil {
                    email = CurrentUser.instance.getEmail()
                }
                let url = "https://firebasestorage.googleapis.com/v0/b/gamerszone-86add.appspot.com/o/profilePhotos%2Fprofpic.png?alt=media&token=39ff50b6-6cb8-4892-a34b-f50410dd749a"
                let userInformation:[String:String] = ["User_Email":email , "username" : username,"call_number":"Unavailable","profileImage": url]
                
                DBProvider.Instance.usersRef.child(CurrentUser.instance.getID()).setValue(userInformation) { (error, ref) -> Void in
                    //Sonst Nutzer Angemeldet und registriert, aber kein Feedback dazu!
                    if error != nil {
                        NotificationsController.sendUserErrorLogin(error: error! as NSError)
                    }
                }
            }
            
        }))
        
        // 4. Present the alert.
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}
