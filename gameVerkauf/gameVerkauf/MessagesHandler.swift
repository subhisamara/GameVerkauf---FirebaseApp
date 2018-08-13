
import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol MessageReceivedDelegate: class{
    func messageReceived(senderID: String, senderName: String, text: String)
    func mediaReceived(senderID: String, senderName: String, url: String)
    
}

class MessagesHandler{
    
    private static let _instance = MessagesHandler()
    
    weak var delegate: MessageReceivedDelegate?
    
    private init(){
    }
    
    static var Instance: MessagesHandler{
        return _instance
    }
    
    func sendMessage(text: String){
        DBProvider.Instance.dbRef.child(Constants.USERS).child(CurrentUser.instance._id).child(Constants.USERNAME).observeSingleEvent(of: .value, with:{ FIRDataSnapshot in
            let username = FIRDataSnapshot.value as? String
            let data: Dictionary<String,Any> = [Constants.SENDER_ID: CurrentUser.instance._id, Constants.SENDER_NAME:username!, Constants.TEXT: text]
            let ref = String(DBProvider.Instance.userMessagesRef.childByAutoId().key)
            DBProvider.Instance.userMessagesRef.child(ref!).setValue(data)
            DBProvider.Instance.userMessagesMirrorRef.child(ref!).setValue(data)
        })
    }
    
    func sendMediaMessage(url: String){
        DBProvider.Instance.dbRef.child(Constants.USERS).child(CurrentUser.instance._id).child(Constants.USERNAME).observeSingleEvent(of: .value, with:{ FIRDataSnapshot in
            if let username = FIRDataSnapshot.value as? String {
                let data : Dictionary<String, Any> = [Constants.SENDER_ID: CurrentUser.instance._id, Constants.SENDER_NAME: username, Constants.URL: url]
            
                //DBProvider.Instance.mediaMessagesRef.childByAutoId().setValue(data)
            
                let ref = String(DBProvider.Instance.mediaMessagesRef.childByAutoId().key)
                DBProvider.Instance.userMessagesRef.child(ref!).setValue(data)
                DBProvider.Instance.userMessagesMirrorRef.child(ref!).setValue(data)
            }
        })
    }
    
    func sendMedia(image: Data){
        if image != nil{
            DBProvider.Instance.imageStorageRef.child(CurrentUser.instance.getID() + "\(NSUUID().uuidString).jpg").put(image , metadata: nil){ (metadata: FIRStorageMetadata?, err: Error?) in
                if err != nil {
                    // inform there was a problem
                } else {
                    self.sendMediaMessage(url: String(describing: metadata!.downloadURL()!))
                }
            }
        }
        
    }
    
    func observeMessages() {
        
        DBProvider.Instance.userMessagesRef.observe(FIRDataEventType.childAdded){
            (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary{
                if let senderID = data[Constants.SENDER_ID] as? String{
                    if let senderName = data[Constants.SENDER_NAME] as? String{
                        if let text = data[Constants.TEXT] as? String{
                            self.delegate?.messageReceived(senderID: senderID, senderName: senderName, text: text)
                        } else if let fileURL = data[Constants.URL] as? String{
                            self.delegate?.mediaReceived(senderID: senderID, senderName: senderName, url: fileURL)
                        }

                    }
                }
            }
        }
    }
    
}
