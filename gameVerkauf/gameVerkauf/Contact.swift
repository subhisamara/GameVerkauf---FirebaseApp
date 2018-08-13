//
//  Contact.swift
//  gameVerkauf
//
//  Created by Subhi M. Samara on 21.06.17.
//
//

import Foundation

class Contact {
    private var _id = ""
    private var _email = ""
    
    init(id: String, email: String){
        _id = id
        _email = email
    }

    var id:String {
        return _id;
    }
    
    var email:String {
        return _email;
    }
    
}
