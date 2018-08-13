//
//  FilterTableViewSection.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 7/29/17.
//
//

import UIKit
class FilterTableViewSection: UIView {
    
    var label: UILabel?
    var button: UIButton?
    var type: Int? //0-Type, 1-Console, 2-Genre
    var state: Bool?
    
    init(_ labelName: String, _ tableWidth: CGFloat, type: Int, state: Bool) {
        super.init(frame: CGRect.zero)
        self.type = type
        self.state = state
        self.backgroundColor = UIColor.lightGray
        let label = UILabel()
        label.text = labelName
        label.textColor = UIColor.white
        label.frame = CGRect(x:8, y:5, width:100, height: 35)
        self.label = label
        
        let button = UIButton()
        
        if(self.state!) {
            button.setTitle("Deselect all", for: .normal)
        }
        else {
            button.setTitle("Select all", for: .normal)
        }
       
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textColor = UIColor.blue
        button.frame = CGRect(x:tableWidth - 112, y:5, width:100, height: 35)
        button.addTarget(self, action: #selector(self.changeButtonState(_:)), for: .touchUpInside)
        self.button = button
       
     
        
      
        self.addSubview(self.label!)
        self.addSubview(self.button!)
    }
    
    func changeButtonState(_ button: UIButton) {
        if(state!){
            self.button?.setTitle("Select All State", for: .normal)
        }
        else{
            self.button?.setTitle("Deselect All State", for: .normal)
        }
        NotificationsController.reloadFilterViewData(type: self.type!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
