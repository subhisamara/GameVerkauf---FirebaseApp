//
//  EntryType.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 16.06.17.
//
//

enum EntryType: String{
    case SALE = "Sale"
    case TRADE = "Trade"
    case SALE_OR_TRADE = "Negotiable"
}

var entryTypeArray: [EntryType] = [ .SALE, .TRADE, .SALE_OR_TRADE]
