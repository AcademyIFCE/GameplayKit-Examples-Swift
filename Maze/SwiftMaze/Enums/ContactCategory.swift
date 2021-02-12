//
//  ContactCategory.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 28/01/21.
//

import Foundation

enum ContactCategory {
    case player, enemy

    var rawValue: UInt32 {
        switch self {
        case .player: return 1 << 1
        case .enemy: return 1 << 2
        }
    }
}
