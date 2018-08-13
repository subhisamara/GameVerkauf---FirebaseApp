//
//  RatingEntry.swift
//  gameVerkauf
//
//  Created by Fabian Frey on 11.07.17.
//
//

import Foundation

class RatingEntry{
    let rating: Int
    let creator: String
    let creatorName : String
    let user : String
    let descriptionText: String
    let created:String
    
    init(rating: Int, creator: String,name:String,user: String, description: String) {
        self.rating = rating
        self.creator = creator
        self.user = user
        self.creatorName = name
        self.descriptionText = description
        self.created = Date().timeIntervalSince1970.description
    }
    
    init(rating: Int, creator: String,name:String,user: String, description: String, created: String) {
        self.rating = rating
        self.creator = creator
        self.user = user
        self.creatorName = name
        self.descriptionText = description
        self.created = created
    }
    
    func getDictionary() -> [String:Any] {
        return ["rating":self.rating,"creator":self.creator,"name":self.creatorName, "user":self.user,"description":self.descriptionText,"created":self.created]
    }
    
}
