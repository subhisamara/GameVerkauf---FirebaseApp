//
//  YTLinkViewController.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 21.06.17.
//
//

import Foundation
import UIKit

class YTLinkViewController: UIViewController{
    
    var videoID : String?
    
    @IBOutlet var uiView: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeView(_:)))
        uiView.addGestureRecognizer(tapGesture)
        uiView.isUserInteractionEnabled = true
        
        let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID!)")
        self.view.backgroundColor = UIColor.black
        
        webView.loadRequest(URLRequest(url: youtubeURL!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func closeView(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
}
