//
//  SpriteComponent.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 28/01/21.
//

import Foundation
import GameplayKit

class SpriteComponent: GKComponent {

    var sprite: SpriteNode?
    var defaultColor: SKColor

    init(defaultColor color: SKColor) {
        self.defaultColor = color
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Appearance
    var pulseEffectEnabled = false {
        didSet {
            if (pulseEffectEnabled) {
                let grow = SKAction.scale(by: 1.5, duration: 0.5)
                let sequence = SKAction.sequence([grow, grow.reversed()])
                self.sprite?.run(SKAction.repeatForever(sequence), withKey: "pulse")
            } else {
                self.sprite?.removeAction(forKey: "pulse")
                self.sprite?.run(SKAction.scale(to: 1, duration: 1))
            }
        }
    }

    func useNormalAppearance() {
        sprite?.color = defaultColor
    }

    func useFleeAppearance() {
        sprite?.color = SKColor.white
    }

    func useDefeatedAppearance() {
        sprite?.run(SKAction.scale(to: 0.25, duration: 0.25))
    }

// MARK: - Movement
    var nextGridPosition: SIMD2<Int32> = .zero {
        didSet {
            if oldValue.x != nextGridPosition.x || oldValue.y != nextGridPosition.y {
                var nextGridActionSequence: [SKAction] = []

                if let scene = sprite?.scene as? GameScene {
                    let point = scene.point(forGridPosition: nextGridPosition)
                    let action = SKAction.move(to: point, duration: 0.35)
                    nextGridActionSequence.append(action)
                }

                let update = SKAction.run({ [weak self] in
                    (self?.entity as? Entity)?.gridPosition = self?.nextGridPosition
                })
                nextGridActionSequence.append(update)

                sprite?.run(SKAction.sequence(nextGridActionSequence), withKey: "move")
            }
        }
    }

    func warp(toGridPosition gridPosition: vector_int2) {
        var warpActionSequence: [SKAction] = []

        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        warpActionSequence.append(fadeOut)

        let update = SKAction.run { [weak self] in
            (self?.entity as? Entity)?.gridPosition = gridPosition
        }
        warpActionSequence.append(update)

        if let scene = sprite?.scene as? GameScene {
            let point = scene.point(forGridPosition: gridPosition)
            let warp = SKAction.move(to: point, duration: 0.5)
            warpActionSequence.append(warp)
        }

        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        warpActionSequence.append(fadeIn)

        sprite?.run(SKAction.sequence(warpActionSequence))
    }

    func followPath(_ path: [GKGridGraphNode]?, completion completionHandler: @escaping () -> Void) {
        // Ignore the first node in the path -- it's the starting position.
        let dropFirst = path?.dropFirst()
        var sequence: [SKAction] = []

        for node in dropFirst ?? [] {

            guard let scene = sprite?.scene as? GameScene,
                  let entity = entity as? Entity else {
                continue
            }

            let point = scene.point(forGridPosition: node.gridPosition)
            sequence.append(SKAction.move(to: point, duration: 0.15))
            sequence.append(
                SKAction.run {
                    entity.gridPosition = node.gridPosition
                }
            )
        }

        sequence.append(SKAction.run(completionHandler))
        sprite?.run(SKAction.sequence(sequence))
    }

}
