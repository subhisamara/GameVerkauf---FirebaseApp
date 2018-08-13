

import UIKit
import FirebaseAuth

class CallerVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func karamButton(_ sender: AnyObject) {
        DBProvider.Instance.saveContact(userID: "OOCCaTlARkYLBYWVRMi4pVL5oVg1", email: "karam@karam.com")
        DBProvider.Instance.saveContactMirror(userID: "OOCCaTlARkYLBYWVRMi4pVL5oVg1", email: (FIRAuth.auth()?.currentUser?.email)!)
    }
    
    @IBAction func subhiButton(_ sender: AnyObject) {
        
        DBProvider.Instance.saveContact(userID: "e7hOTIMU7ISTTNGTH9VuCmi3Poi1", email: "subhi@subhi.com")
        DBProvider.Instance.saveContactMirror(userID: "e7hOTIMU7ISTTNGTH9VuCmi3Poi1", email: (FIRAuth.auth()?.currentUser?.email)!)
    }
    
    
}
