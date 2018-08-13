import Foundation
import FirebaseAuth

class CurrentContact{
    var ID = ""
    var userName = ""
    var number = ""
    static let instance = CurrentContact()
    
    init() {
        self.setData()
    }
    
    init(id:String) {
        self.ID = id
    }
    
    func setData() {
        if self.ID != "" {
            let reference = DBProvider.Instance.dbRef
            let ref = reference.child("Users").child(self.ID)
            ref.observe(.value, with: { (snapshot) in
                if let userInformation = snapshot.value as? NSDictionary {
                    self.userName = userInformation["username"] as! String
                    self.number = userInformation["call_number"] as! String
                    NotificationsController.sendUcall_numberNotification(call_number: self.number)
                    NotificationsController.sendUserNameNotification(user: self.userName)
                }
            })
        }
    }

}
