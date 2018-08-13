//
//  ReviewViewController.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 7/12/17.
//
//

import UIKit
class ReviewViewController: UIViewController, UIWebViewDelegate {
    
    var gameEntry: GameEntry? = nil
    
    @IBOutlet weak var webView: UIWebView! {
        didSet {
            webView.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let spiel = gameEntry!.name
        let spielToURL:String = spiel.replacingOccurrences(of: " ", with: "+")
        
        webView.loadRequest(URLRequest(url: URL(string: "http://m.ign.com/search?q=\(spielToURL)&page=0&count=5&type=object&objectType=game&filter=games&")!))
    }

    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        PopupModel.shared.startActivityIndicator(text: "Loading", width: 100, height: 100)
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        PopupModel.shared.stopActivityIndicator()
    }
    
    func setGameEntry(gameEntry: GameEntry) {
        self.gameEntry = gameEntry
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


