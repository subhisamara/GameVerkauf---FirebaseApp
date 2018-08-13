//
//  ConsoleType.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 16.06.17.
//
//
enum ConsoleType: String {
    
    case PC = "PC"
    
    //Sony
    case PS1 = "PlayStation"
    case PS2 = "PlayStation 2"
    case PS3 = "PlayStation 3"
    case PS4 = "PlayStation 4"
    case Vita = "PS Vita"
    case PSP = "PlayStation Portable"
    
    //Microsoft
    case XBOX = "Xbox"
    case X360 = "Xbox 360"
    case XONE = "Xbox One"
    
    //Nintendo
    case NES = "NES"
    case SNES = "SNES"
    case N64 = "Nintendo 64"
    case GC = "Nintendo GameCube"
    case WII = "Nintendo Wii"
    case WIIU = "Nintendo Wii U"
    
    case GB = "GameBoy"
    case DS = "Nintendo DS"
    case N3DS = "Nintendo 3DS"
    
    //TODO: More?
}

var consoleTypArray = [ConsoleType.PC, ConsoleType.PS1, ConsoleType.PS2, ConsoleType.PS3, ConsoleType.PS4, ConsoleType.Vita, ConsoleType.PSP, ConsoleType.XBOX, ConsoleType.X360, ConsoleType.XONE, ConsoleType.NES, ConsoleType.SNES, ConsoleType.N64, ConsoleType.GC, ConsoleType.WII, ConsoleType.WIIU, ConsoleType.GB, ConsoleType.DS, ConsoleType.N3DS]
