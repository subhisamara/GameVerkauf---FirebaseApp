//
//  GameEntry.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 16.06.17.
//
//
import UIKit
import SDWebImage

class GameEntry{
    var name: String
    var console: ConsoleType!
    var genre: GenreType!
    var price: Float
    var type: EntryType
    var image: UIImage
    var description: String
    var ownerName: String //User ID
    var owner: String
    var date: Date
    var url: URL?
    
    init(name: String, genre: GenreType, console: ConsoleType, price: Float, type: EntryType, image: UIImage, description: String, owner: String, ownerName: String, date: Date) {
        self.name = name
        self.console = console
        self.genre = genre
        self.price = price
        self.type = type
        self.image = image
        self.description = description
        self.owner = owner
        self.ownerName = ownerName
        self.date = date
        self.url = nil
    }
    
    init(name: String, genre: GenreType, console: ConsoleType, price: Float, type: EntryType, imageUrl: String, description: String, owner: String, ownerName: String, date: Date) {
        self.name = name
        self.console = console
        self.genre = genre
        self.price = price
        self.type = type
        self.description = description
        self.owner = owner
        self.ownerName = ownerName
        self.image = UIImage(named: "addImage")!
        self.date = date
        self.url = URL(string: imageUrl)

        NotificationsController.reloadEntriesTableViewData()
    
    }
    
    func updateImage(newImage: UIImage) {
        self.image = newImage
    }
    
    func getDictionary() -> [String:String] {
        return ["name":self.name,"genre":genre.rawValue,"platform":console.rawValue,"price":String(price),"type":type.rawValue,"description":description, "owner":owner,"ownerName":ownerName,"date": String(date.timeIntervalSince1970)]
    }
    
    func getDictionary(url: String) -> [String:String] {
        return ["name":self.name,"genre":genre.rawValue,"image": url, "platform":console.rawValue,"price":String(price),"type":type.rawValue,"description":description, "owner":owner, "ownerName":ownerName, "date": String(date.timeIntervalSince1970)]
    }
    
}
