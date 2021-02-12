//
//  PlayerControlComponent.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 28/01/21.
//

import Foundation
import GameplayKit

class PlayerControlComponent: GKComponent {

    private var nextNode: GKGridGraphNode?

    var level: Level
    var direction: PlayerDirection = .none {
        willSet {
            var proposedNode: GKGridGraphNode?

            if let nextNode = self.nextNode,
               let nodeInDirection = self.nodeInDirection(newValue, fromNode: nextNode),
               self.direction != PlayerDirection.none {

                proposedNode = nodeInDirection

            } else if let entity = entity as? Entity,
                      let entityGridPosition = entity.gridPosition,
                      let currentNode = self.level.pathfindingGraph?.node(atGridPosition: entityGridPosition) {

                proposedNode = currentNode

            }

            if proposedNode == nil {
                return
            }

            self.direction = newValue
        }
    }
    var attemptedDirection: PlayerDirection = .none

    init(level: Level) {
        self.level = level
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func nodeInDirection(_ direction: PlayerDirection, fromNode node: GKGridGraphNode) -> GKGridGraphNode? {
        var nextPosition: SIMD2<Int32>
        switch direction {
        case .left:
            nextPosition = node.gridPosition &+ SIMD2<Int32>(-1,0)
        case .right:
            nextPosition = node.gridPosition &+ SIMD2<Int32>(1,0)
        case .down:
            nextPosition = node.gridPosition &+ SIMD2<Int32>(0,-1)
        case .up:
            nextPosition = node.gridPosition &+ SIMD2<Int32>(0,1)
        case .none:
            return nil
        }
        return self.level.pathfindingGraph?.node(atGridPosition: nextPosition)
    }

    func makeNextMove() {
        guard let entity = self.entity as? Entity,
              let entityGridPosition = entity.gridPosition,
              let levelPathFindingGraph = self.level.pathfindingGraph,
              let currentNode = levelPathFindingGraph.node(atGridPosition: entityGridPosition) else {
            return
        }

        let direction = self.direction
        let nextNode = self.nodeInDirection(direction, fromNode: currentNode)

        if let attemptedNextNode = self.nodeInDirection(self.attemptedDirection, fromNode: currentNode) {
            // Move in attempted direction
            self.direction = self.attemptedDirection
            self.nextNode = attemptedNextNode
            let component = entity.component(ofType: SpriteComponent.self)
            if let selfNextNode = self.nextNode {
                component?.nextGridPosition = selfNextNode.gridPosition
            }
        } else if let nextNode = nextNode {
            // Keep moving in the same direction
            self.nextNode = nextNode
            let component = entity.component(ofType: SpriteComponent.self)
            if let selfNextNode = self.nextNode {
                component?.nextGridPosition = selfNextNode.gridPosition
            }
        } else {
            // Can't move anymore
            self.direction = PlayerDirection.none
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        self.makeNextMove()
    }
}
