//
//  PopupModel.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 25.05.17.
//  Copyright © 2017 Fabian Frey. All rights reserved.
//

import Foundation
import UIKit

class PopupModel {
    
    static let shared = PopupModel()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView() {
        didSet {
            self.activityIndicator.hidesWhenStopped = true
        }
    }
    
    @objc func startActivityIndicator(text: String, width: Int, height: Int) {
              DispatchQueue.main.async {
        self.activityIndicator.frame = CGRect(x: 0,y: 0,width:width, height: height)
        let label = UILabel(frame: CGRect(x: 0,y: height - 30 ,width: width, height: 20))
        label.textColor = UIColor.black
        label.text = text
        label.textAlignment = .center
        self.activityIndicator.addSubview(label)
        self.activityIndicator.center = UIApplication.topViewController()!.view.center
        self.activityIndicator.activityIndicatorViewStyle = .whiteLarge
        self.activityIndicator.color = UIColor.black
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.backgroundColor = UIColor(white: 0.66, alpha: 0.95)
        self.activityIndicator.layer.cornerRadius = 10
        UIApplication.topViewController()!.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        if !UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        }
    }
    
    @objc func stopActivityIndicator() {
        
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
    
    static func newNotificationWithOneButton(_ headline: String, message: String, buttonMessage: String){
        let alertController = UIAlertController(title: headline, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: buttonMessage, style: UIAlertActionStyle.default, handler: nil))
        
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
       
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
