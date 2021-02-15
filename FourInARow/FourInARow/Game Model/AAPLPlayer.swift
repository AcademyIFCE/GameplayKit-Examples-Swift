//
//  AAPLPlayer.swift
//  FourInARow
//

import UIKit
import GameplayKit

enum AAPLChip: Int {
    case none = 0
    case red
    case black
}

class AAPLPlayer: NSObject {
    
    static var allPlayers = [AAPLPlayer(chip: .red), AAPLPlayer(chip: .black)]
    
    static var red: AAPLPlayer {
        return player(for: .red)!
    }
    
    static var black: AAPLPlayer {
        return player(for: .black)!
    }

    var chip: AAPLChip
    
    var name: String? {
        switch chip {
            case .red:
                return "Red"
            case .black:
                return "Black"
            default:
                return nil
        }
    }
    
    var color: UIColor? {
        switch chip {
            case .red:
                return UIColor.red
            case .black:
                return UIColor.black
            default:
                return nil
        }
    }
    
    var opponent: AAPLPlayer? {
        switch chip {
            case .red:
                return AAPLPlayer.black
            case .black:
                return AAPLPlayer.red
            default:
                return nil
        }
    }
    
    override var debugDescription: String {
        switch chip {
            case .red:
                return "X"
            case .black:
                return "O"
            default:
                return " "
        }
    }
    
    init(chip: AAPLChip) {
        self.chip = chip
    }
    
    class func player(for chip: AAPLChip) -> AAPLPlayer? {
        if chip == .none {
            return nil
        } else {
            // Chip enum is 0/1/2, array is 0/1.
            return allPlayers[chip.rawValue-1]
        }
    }

}
