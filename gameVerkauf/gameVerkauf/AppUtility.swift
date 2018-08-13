//
//  AppUtility.swift
//  gameVerkauf
//
//  Created by Subhi M. Samara on 15.07.17.
//
//

import Foundation

import Foundation
import UIKit

struct AppUtility {
    
    // This method will force you to use base on how you configure.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    // This method done pretty well where we can use this for best user experience.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}


/*
 
In order to disable orientation and keep it only prtaot, please ass the following to your VC:
 
 oxxverride func viewDidAppear(_ animated: Bool) {
 super.viewDidAppear(animated)
 AppUtility.lockOrientation(.portrait)
 }
 
 override func viewWillDisappear(_ animated: Bool) {
 super.viewWillDisappear(animated)
 AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight], andRotateTo: .portrait)
 }
 */
