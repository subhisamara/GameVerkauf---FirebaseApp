

import UIKit

class ChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource,FetchData{
    @IBOutlet weak var tableView: UITableView!
    
    private let CHAT_SEGUE="ChatSegue"
    private var contacts=[Contact]()
    var deleteContactIndexPath: NSIndexPath? = nil
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // which mean you are forced to use portrait.
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .portrait)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.background()
        DBProvider.Instance.delegate=self
        DBProvider.Instance.getContacts()
        DBProvider.Instance.observeContacts()
        tableView.reloadData()
    }
    
    func background(){
        let backgroundImage = UIImage(named: "Background.png")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        self.tableView.backgroundView = imageView
        self.tableView.backgroundView?.contentMode = .scaleToFill
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func dataReceived(recievedContacts: [Contact]) {
        self.contacts = recievedContacts
        tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CurrentContact.instance.ID = contacts[indexPath.row].id
        performSegue(withIdentifier: CHAT_SEGUE, sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell;
        DBProvider.Instance.dbRef.child(Constants.USERS).child(contacts[indexPath.row].id).child(Constants.USERNAME).observeSingleEvent(of: .value, with:{ FIRDataSnapshot  in
            cell.textLabel?.text = FIRDataSnapshot.value as? String
            cell.textLabel?.font.withSize(18)
            cell.textLabel?.textColor = UIColor(red: 0, green: 255, blue: 255, alpha: 1.0)
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteContactIndexPath = indexPath as NSIndexPath
            let contactToDelete = contacts[indexPath.row]
            confirmDelete(contact: contactToDelete)
        }
    }
    
    func confirmDelete(contact: Contact) {
        DBProvider.Instance.dbRef.child(Constants.USERS).child(contact.id).child(Constants.USERNAME).observeSingleEvent(of: .value, with:{ FIRDataSnapshot  in
            let username = FIRDataSnapshot.value as? String
            let alert = UIAlertController(title: "Delete Contact", message: "Are you sure you want to permanently delete" + username! + "?", preferredStyle: .actionSheet)
            let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteContact)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteContact)
            alert.addAction(DeleteAction)
            alert.addAction(CancelAction)
            // Support display in iPad
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect.init(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            self.present(alert, animated: true, completion: nil)
        })

    }
    
    func handleDeleteContact(alertAction: UIAlertAction!) -> Void {
        let id = self.contacts[(deleteContactIndexPath?.item)!].id
        if let indexPath = deleteContactIndexPath {
            tableView.beginUpdates()
            DBProvider.Instance.userContactsRef.child(id).removeValue { (error, ref) in
                if error != nil {
                }
            }
            contacts.remove(at: indexPath.row)
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            deleteContactIndexPath = nil
            tableView.endUpdates()
        }
    }
    func myDeleteFunction(childIWantToRemove: String) {
        
        DBProvider.Instance.dbRef.child(childIWantToRemove)    }
    
    func cancelDeleteContact(alertAction: UIAlertAction!) {
        deleteContactIndexPath = nil
    }
}
