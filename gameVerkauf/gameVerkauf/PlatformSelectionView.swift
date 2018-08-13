//
//  PlatformSelectionView.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 24.06.17.
//
//

import UIKit

class PlatformSelectionView: UIView, UIPickerViewDelegate,UIPickerViewDataSource {
    var platform:ConsoleType? = nil
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        if let console = self.platform {
            NotificationsController.platformPickedNotification(type: console)
        }
        removeFromSuperview()
    }
    
    @IBOutlet weak var headline: UILabel!

    @IBOutlet weak var platformPicker: UIPickerView! {
        didSet {
            platformPicker.dataSource = self
            platformPicker.delegate = self
            
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.darkGray.cgColor
            self.layer.shadowOffset = CGSize(width: 4, height: 4)
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 3
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.viewDismiss))
            self.addGestureRecognizer(gesture)
        }
    }
    
    func viewDismiss() {
        self.removeFromSuperview()
    }
    
    // MARK: - Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consoleTypArray.count+1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return ""
        }
        return consoleTypArray[row-1].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            platform = consoleTypArray[row-1]
        }
    }
}
