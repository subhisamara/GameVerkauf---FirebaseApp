//
//  FilterViewController.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 28.06.17.
//
//

import UIKit
class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var deselect:Bool = true
    
    var sectionState: [Bool] = [true, true, true]
    
    @IBOutlet weak var deselectAllButton: UIButton!
    @IBAction func deselectAllButtons(_ sender: Any) {
        if deselect {
            FilterObject.shared.consoles = []
            FilterObject.shared.types = []
            FilterObject.shared.genres = []
            deselectAllButton.setTitle("Select all", for: .normal)
            
        } else {
            FilterObject.shared.setAllCategories()
            deselectAllButton.setTitle("Deselect all", for: .normal)
            
        }
       
        self.deselect = !self.deselect
        tableView.reloadData()
    }
    
    let sectionNames: [String] = ["Type", "Console", "Genre"]

    //Section 1
    let typeData: [String] = entryTypeArray.map { $0.rawValue }
    
    //Section 2
    let consoleData: [String] = consoleTypArray.map{ $0.rawValue }
    
    //Section 3
    let genreData: [String] = genreTypeArray.map{ $0.rawValue }
    
    var allSectionsData: [Int: [String]] = [:]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "FilterTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.allSectionsData = [0: typeData, 1: consoleData, 2: genreData]
        
        if (FilterObject.shared.consoles.isEmpty && FilterObject.shared.types.isEmpty && FilterObject.shared.genres.isEmpty) {
            deselectAllButton.setTitle("Select All", for: .normal)
            deselect=false
        }
        
        if (FilterObject.shared.types.isEmpty) {
            
            sectionState[0] = false
        }
        
        if (FilterObject.shared.consoles.isEmpty) {
            sectionState[1] = false
        }
        
        if (FilterObject.shared.genres.isEmpty) {
            sectionState[2] = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadFilter(_:)), name: NSNotification.Name(rawValue: "reloadFilter"), object: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (allSectionsData[section]?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterTableViewCell

        cell.filterLabel.text = allSectionsData[indexPath.section]![indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let text = cell.filterLabel.text

        let testType = EntryType(rawValue: text!)
        let testConsole = ConsoleType(rawValue: text!)
        let testGenre = GenreType(rawValue: text!)
        
    
        if (testType != nil && FilterObject.shared.types.contains(testType!))||(testConsole != nil && FilterObject.shared.consoles.contains(testConsole!))||(testGenre != nil && FilterObject.shared.genres.contains(testGenre!)){
            
            cell.filterCheckButton.image = #imageLiteral(resourceName: "checkbox-checked")
            cell.checked = true
        }
        else{
            cell.filterCheckButton.image = #imageLiteral(resourceName: "checkbox-unchecked")
            cell.checked = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        let text = cell.filterLabel.text
        if cell.checked == true {
            cell.filterCheckButton.image = #imageLiteral(resourceName: "checkbox-unchecked")
            
            if EntryType(rawValue: text!) != nil && FilterObject.shared.types.contains(EntryType(rawValue: text!)!){
                FilterObject.shared.types = FilterObject.shared.types.filter {$0 != EntryType(rawValue: text!)!}
            }
            else if ConsoleType(rawValue: text!) != nil && FilterObject.shared.consoles.contains(ConsoleType(rawValue: text!)!){
                FilterObject.shared.consoles = FilterObject.shared.consoles.filter {$0 != ConsoleType(rawValue: text!)!}
            }
            else if GenreType(rawValue: text!) != nil && FilterObject.shared.genres.contains(GenreType(rawValue: text!)!){
                FilterObject.shared.genres = FilterObject.shared.genres.filter{ $0 != GenreType(rawValue: text!)!}
            }
        }
        else {
            cell.filterCheckButton.image = #imageLiteral(resourceName: "checkbox-checked")
            if EntryType(rawValue: text!) != nil && !FilterObject.shared.types.contains(EntryType(rawValue: text!)!){
                FilterObject.shared.types.append(EntryType(rawValue: text!)!)
            }
            else if ConsoleType(rawValue:text!) != nil && !FilterObject.shared.consoles.contains(ConsoleType(rawValue: text!)!){
                FilterObject.shared.consoles.append(ConsoleType(rawValue: text!)!)
            }
            else if GenreType(rawValue:text!) != nil && !FilterObject.shared.genres.contains(GenreType(rawValue: text!)!){
                FilterObject.shared.genres.append(GenreType(rawValue: text!)!)
            }
            
        }
        cell.checked = !cell.checked!
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = FilterTableViewSection(sectionNames[section], self.tableView.contentSize.width, type: section, state: sectionState[section])        
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func reloadFilter(_ notification: NSNotification) {
        let type = notification.object as! Int
        sectionState[type] = !sectionState[type]
        switch(type) {
        case 0:
            if sectionState[type] {
                FilterObject.shared.setAllTypes()
            }
            else {
                FilterObject.shared.types = []
            }
        case 1:
            if sectionState[type] {
                FilterObject.shared.setAllConsoles()
            }
            else {
                FilterObject.shared.consoles = []
            }
        case 2:
            if sectionState[type] {
                FilterObject.shared.setAllGenres()
            }
            else {
                FilterObject.shared.genres = []
            }
        
        default: print(type)
        
        }
        self.tableView.reloadData()
    }
    
}
