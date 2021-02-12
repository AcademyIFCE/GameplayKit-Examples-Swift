//
//  GameScene.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 18/01/21.
//

import Foundation
import GameplayKit
import SpriteKit

let cellWidth: Int = 27

class GameScene: SKScene {

    weak var sceneDelegate: GameSceneDelegate?

    override func didMove(to view: SKView?) {
        sceneDelegate?.scene(self, didMoveTo: view)
    }

    override func update(_ currentTime: TimeInterval) {
        if let game = sceneDelegate as? Game {
            game.update(currentTime, for: self)
        }
    }

    func point(forGridPosition position: SIMD2<Int32>) -> CGPoint {
        return CGPoint(
            x: Int(position.x) * cellWidth + cellWidth / 2,
            y: Int(position.y) * cellWidth + cellWidth / 2
        )
    }

    #if os(macOS)
    override func keyDown(with theEvent: NSEvent) {

        switch Int(theEvent.keyCode) {
        case 123:
            sceneDelegate?.playerDirection = PlayerDirection.left
        case 124:
            sceneDelegate?.playerDirection = PlayerDirection.right
        case 125:
            sceneDelegate?.playerDirection = PlayerDirection.down
        case 126:
            sceneDelegate?.playerDirection = PlayerDirection.up
        case 49: /* space */
            sceneDelegate?.hasPowerup = true
        default:
            break
        }
    }
    #endif

}
