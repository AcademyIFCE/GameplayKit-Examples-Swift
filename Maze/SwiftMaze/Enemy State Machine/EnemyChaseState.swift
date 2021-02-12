//
//  EnemyChaseState.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 28/01/21.
//

import Foundation
import GameplayKit

class EnemyChaseState: EnemyState {

    private var ruleSystem: GKRuleSystem

    private var hunting: Bool = false {
        willSet {
            if (self.hunting != newValue) {
                if (!newValue) {
                    let enemyStartPositions = self.game.level.enemyStartPositions
                    if let random = self.game.random,
                       let positions = random.arrayByShufflingObjects(in: enemyStartPositions) as? [GKGridGraphNode] {
                        self.scatterTarget = positions.first
                    }
                }
            }
            self.hunting = newValue
        }
    }

    private var scatterTarget: GKGridGraphNode!

    override init(game: Game, entity: Entity) {
        self.ruleSystem = GKRuleSystem()

        super.init(game: game, entity: entity)

        let playerFar: NSPredicate = NSPredicate(format: "$distanceToPlayer.floatValue >= 10.0")
        let playerFarRule = GKRule(predicate: playerFar, assertingFact: "hunt" as NSObjectProtocol, grade: 1)
        self.ruleSystem.add(playerFarRule)

        let playerNear: NSPredicate = NSPredicate(format: "$distanceToPlayer.floatValue < 10.0")
        let playerNearRule = GKRule(predicate: playerNear, retractingFact: "hunt" as NSObjectProtocol, grade: 1)
        self.ruleSystem.add(playerNearRule)
    }

    func pathToPlayer() -> [GKGridGraphNode] {
        if let graph = self.game.level.pathfindingGraph,
           let playerGridPosition = self.game.player.gridPosition,
           let playerNode = graph.node(atGridPosition: playerGridPosition) {
            return self.path(to: playerNode) ?? []
        }
        return []
    }

    // MARK: - GKState Life Cycle
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        super.isValidNextState(stateClass)
        return stateClass == EnemyFleeState.self
    }

    override func didEnter(from previousState: GKState?) {
        if let component = self.entity.component(ofType: SpriteComponent.self) {
            component.useNormalAppearance()
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)

        if let position: SIMD2<Int32> = self.entity.gridPosition,
           position.x == self.scatterTarget?.gridPosition.x,
           position.y == self.scatterTarget?.gridPosition.y {
            self.hunting = true
        }

        let distanceToPlayer = self.pathToPlayer().count
        self.ruleSystem.state["distanceToPlayer"] = distanceToPlayer

        self.ruleSystem.reset()
        self.ruleSystem.evaluate()

        self.hunting = self.ruleSystem.grade(forFact: "hunt" as NSObjectProtocol) > 0
        if self.hunting {
            self.start(followingPath: self.pathToPlayer())
        } else {
            self.start(followingPath: self.path(to: self.scatterTarget))
        }
    }

}
