//
//  GameSceneDelegate.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 28/01/21.
//

import Foundation
import SpriteKit

/// This protocol moves most of the game logic to the delegate,
/// leaving the scene class to only handle input.
protocol GameSceneDelegate: SKSceneDelegate {
    var hasPowerup: Bool { get set }
    var playerDirection: PlayerDirection { get set }
    func scene(_ scene: GameScene?, didMoveTo view: SKView?)
}
