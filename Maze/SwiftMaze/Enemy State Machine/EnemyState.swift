//
//  EnemyState.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 28/01/21.
//

import Foundation
import GameplayKit

class EnemyState: GKState {
    weak var game: Game!
    var entity: Entity

    init(game: Game, entity: Entity) {
        self.game = game
        self.entity = entity
        super.init()
    }

// MARK: - Path Finding & Following
    func path(to node: GKGridGraphNode) -> [GKGridGraphNode]? {
        guard let game = game, let gridPosition = entity.gridPosition else {
            return nil
        }

        let graph = game.level.pathfindingGraph
        let enemyNode = graph?.node(atGridPosition: gridPosition)

        if let enemyNode = enemyNode {
            return graph?.findPath(from: enemyNode, to: node) as? [GKGridGraphNode]
        }

        return nil
    }

    func start(followingPath path: [GKGridGraphNode]?) {
        /*
         Set up a move to the first node on the path, but no
         farther because the next update will recalculate the path.
        */
        guard let path = path else { return }
        if (path.count > 1) {
            let firstMove = path[1] // path[0] is the enemy's current position.
            let component = entity.component(ofType: SpriteComponent.self)
            component?.nextGridPosition = firstMove.gridPosition
        }
    }
}
