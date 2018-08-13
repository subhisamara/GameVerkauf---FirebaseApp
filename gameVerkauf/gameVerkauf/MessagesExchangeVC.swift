import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import SDWebImage
import FirebaseAuth

class MessagesExchangeVC: JSQMessagesViewController, MessageReceivedDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var urls = ""
    var sender:UIImage!
    var reciever:UIImage!
    var messages = [JSQMessage]()
    let picker = UIImagePickerController()
    @IBOutlet weak var navigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImages()
        self.settings()
        self.background()
        self.keyBoardControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
        
        
        //ScrollView to show last message
        //scrollToBottom(animated: true)
        self.automaticallyScrollsToMostRecentMessage = true
        
        
        //Starting with Keyboard
        //self.inputToolbar.contentView.textView.becomeFirstResponder()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //Disabling Tabbar to see Input Toolbar
        self.tabBarController?.setTabBarVisible(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .portrait)
        self.tabBarController?.setTabBarVisible(true, animated: true)
    }
    
    
    private func setImages(){
        let reference = DBProvider.Instance.usersRef
        let ref = reference.child(CurrentContact.instance.ID)
        ref.observe(.value, with: { (snapshot) in
            if let userInformation = snapshot.value as? NSDictionary {
                self.urls = userInformation["profileImage"] as! String
                if let url2 = URL(string: self.urls){
                    do{
                        let data2 = try Data(contentsOf: url2)
                        if let receiverPic = UIImage(data: data2){
                            self.reciever = receiverPic
                            NotificationsController.sendProfileImageURLReceivedNotification(url: self.urls)
                        } else {
                            self.reciever = #imageLiteral(resourceName: "ProfileIMG")
                        }
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            }
        })
        sender = CurrentUser.instance.userImage
    }
    func DoCall(){
        let caller: UIBarButtonItem = UIBarButtonItem.init(title: "Call", style: .plain, target: self, action: #selector(self.call))
        
        self.navigation.rightBarButtonItem = caller
    }
    
    func call() {
        if CurrentContact.instance.ID != "" {
            
            print(CurrentContact.instance.number)
            if CurrentContact.instance.number != "Unavailable" && CurrentContact.instance.number != "" && CurrentContact.instance.userName != CurrentUser.instance.userName{
                if let url = URL(string: "tel://\(CurrentContact.instance.number)") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url as URL)
                    }
                }
                
            }else {
                let alert = UIAlertController(title: "Warning" , message:CurrentContact.instance.userName + "Does not have a number to call", preferredStyle: .actionSheet)
                let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(CancelAction)
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = CGRect.init(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
                
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }

    }
    
    func settings(){
        CurrentContact.instance.setData()
        DBProvider.Instance.userMessagesRef.removeAllObservers()
        picker.delegate = self
        self.navigationItem.rightBarButtonItem?.title = "call"
        self.DoCall()
                MessagesHandler.Instance.delegate = self
        self.senderId = Constants.CURRENTUSER_ID
        MessagesHandler.Instance.observeMessages()
        self.senderDisplayName = CurrentUser.instance.userName
        let ref = DBProvider.Instance.usersRef.child(CurrentContact.instance.ID)
        ref.observe(.value, with: { (snapshot) in
            if let userInformation = snapshot.value as? NSDictionary {
                self.navigation.title = userInformation["username"] as? String
            } else{
                self.navigation.title = "Chat"
            }
        })
    }
    
    
    func background(){
        let backgroundImage = UIImage(named: "Background.png")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        self.collectionView.backgroundView = imageView
    }
    
    func keyBoardControl(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func keyboardWillShow(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
    let window = self.view.window?.frame {
    self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: window.origin.y + window.height - keyboardSize.height)
    keyboardController.textView.autocorrectionType = .no
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,y: self.view.frame.origin.y, width: self.view.frame.width, height: viewHeight + keyboardSize.height)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        if message.senderId == self.senderId{
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
            
        }else{
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.black)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == self.senderId{
            return JSQMessagesAvatarImageFactory.avatarImage(with: self.sender, diameter: 30)
        } else{
            return JSQMessagesAvatarImageFactory.avatarImage(with: self.reciever, diameter: 30)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let msg = messages[indexPath.item]
        if msg.isMediaMessage{
            if let mediaItem = msg.media as? JSQVideoMediaItem{
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present( playerController ,animated: true, completion: nil)
            }
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        collectionView.reloadData()
        MessagesHandler.Instance.sendMessage(text: text)
        scrollToBottom(animated: true)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.automaticallyScrollsToMostRecentMessage = true
        finishSendingMessage()

    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "Media Messages", message: "Please Select A Media", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photos = UIAlertAction(title: "Photos", style: .default, handler: {(aler: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage)
        })
        alert.addAction(photos)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func chooseMedia(type: CFString){
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let data = UIImageJPEGRepresentation(pic, 0.01)
            MessagesHandler.Instance.sendMedia(image: data!)
        }
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
    
    func messageReceived(senderID: String, senderName: String, text: String) {
        messages.append(JSQMessage(senderId: senderID, displayName: senderName, text: text))
        scrollToBottom(animated: true)
        self.automaticallyScrollsToMostRecentMessage = true
        collectionView.reloadData()
    }
    
    func mediaReceived(senderID: String, senderName: String, url: String) {
        if let mediaURL = URL(string : url){
            do {
                let data = try Data(contentsOf: mediaURL)
                if let _ = UIImage(data: data){
                    let _ = SDWebImageDownloader.shared().downloadImage(with: mediaURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                        DispatchQueue.main.async {
                            let photo = JSQPhotoMediaItem(image: image)
                            if senderID == self.senderId {
                                photo?.appliesMediaViewMaskAsOutgoing = true
                            }else {
                                photo?.appliesMediaViewMaskAsOutgoing = false
                            }
                            self.messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: photo))
                            self.scrollToBottom(animated: true)
                            self.automaticallyScrollsToMostRecentMessage = true
                            self.collectionView.reloadData()
                        }
                    })
                }
                
            }catch {
                print("Media can not be recieved")
            }
            
        }
        
    }

}

/*
 @IBAction func edit(_ sender: Any) {
 let optionMenu = UIAlertController(title: nil, message: "Change", preferredStyle: .actionSheet)
 self.present(optionMenu, animated: true, completion: nil)
 }
 */
