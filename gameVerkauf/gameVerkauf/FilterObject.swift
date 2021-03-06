//
//  FilterObject.swift
//  gameVerkauf
//
//  Created by Subhi M. Samara on 21.06.17.
//
//

class FilterObject {
    
    //Singleton
    static let shared = FilterObject()
    
    var types: [EntryType] = []
    var consoles: [ConsoleType] = []
    var genres: [GenreType] = []
    
    init() {
        setAllCategories()
    }
    
    func setAllCategories() {
        setAllTypes()
        setAllConsoles()
        setAllGenres()
    }
    
    func setAllTypes(){
        self.types = entryTypeArray
    }
    
    func setAllConsoles() {
        self.consoles = consoleTypArray
    }
    
    func setAllGenres() {
        self.genres = genreTypeArray
    }
}
