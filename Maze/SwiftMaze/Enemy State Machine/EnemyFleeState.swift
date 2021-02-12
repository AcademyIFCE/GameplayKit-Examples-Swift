//
//  EnemyFleeState.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 28/01/21.
//

import Foundation
import GameplayKit

class EnemyFleeState: EnemyState {

    private var target: GKGridGraphNode!

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == EnemyChaseState.self || stateClass == EnemyDefeatedState.self
    }

    // MARK: - GKState Life Cycle

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        guard let component = self.entity.component(ofType: SpriteComponent.self) else { return }
        component.useFleeAppearance()

        //choose location to flee towards
        if let random = self.game.random,
           let targets = random.arrayByShufflingObjects(in: self.game.level.enemyStartPositions) as? [GKGridGraphNode],
           let targetNode = targets.first {
            self.target = targetNode
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        // If the enemy has reached its target, choose a new target.
        if let random = self.game.random,
           let position: SIMD2<Int32> = self.entity.gridPosition,
           position.x == self.target.gridPosition.x,
           position.y == self.target.gridPosition.y,
           let targets = random.arrayByShufflingObjects(in: self.game.level.enemyStartPositions) as? [GKGridGraphNode],
           let targetNode = targets.first {
            self.target = targetNode
        }

        // Flee towards the current target point.
        self.start(followingPath: self.path(to: self.target))
    }

}
