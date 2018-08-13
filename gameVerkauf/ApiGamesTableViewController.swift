//
//  ApiGamesTableViewController.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 01.07.17.
//
//

import UIKit

class ApiGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tableData:[[String:Any]] = []
    var searchBarText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }
    
    //updates filtered data based on the text in the search box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBarText = searchText
        //PopupModel.shared.startActivityIndicator(text: "Loading", width: 100, height: 100)
        var searchText = self.searchBarText
        searchText = searchText.replacingOccurrences(of: " ", with: "+")
        
        let headers:[String:String] = ["X-Mashape-Key":"QaS6Hi2qXxmshTwZuE7XrnaLdomRp1GLQJhjsneovxomJqpfDT","Accept":"application/json"]
        
        if let url = URL(string:"https://igdbcom-internet-game-database-v1.p.mashape.com/games/?fields=name%2Cgenres%2Ccover%2Csummary&limit=50&offset=0&search=\(searchText)") {
            var req = URLRequest(url: url)
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
                //PopupModel.shared.stopActivityIndicator()
                for elem in array! {
                    tableDataArray.append(elem)
                }
                self.tableData = tableDataArray
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
            task.resume()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameNameCell", for: indexPath)

        cell.textLabel?.text = self.tableData[indexPath.row]["name"] as? String

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = self.tableData[indexPath.row]
        NotificationsController.apiGameSelectedNotification(game: game as NSDictionary)
        self.navigationController?.popToRootViewController(animated: true)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
