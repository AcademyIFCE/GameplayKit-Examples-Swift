//
//  EnemyDefeatedState.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 28/01/21.
//

import Foundation
import GameplayKit

class EnemyDefeatedState: EnemyState {

    var respawnPosition: GKGridGraphNode!

    // MARK: - GKState Life Cycle

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        super.isValidNextState(stateClass)
        return stateClass == EnemyRespawnState.self
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        guard let component = self.entity.component(ofType: SpriteComponent.self) else { return }
        component.useDefeatedAppearance()

        if let graph: GKGridGraph = self.game.level.pathfindingGraph,
           let entityGridPosition = self.entity.gridPosition,
           let enemyNode: GKGridGraphNode = graph.node(atGridPosition: entityGridPosition),
           let path = graph.findPath(from: enemyNode, to: self.respawnPosition) as? [GKGridGraphNode] {

            component.followPath(path) {
                self.stateMachine?.enter(EnemyRespawnState.self)
            }

        }

    }
}
