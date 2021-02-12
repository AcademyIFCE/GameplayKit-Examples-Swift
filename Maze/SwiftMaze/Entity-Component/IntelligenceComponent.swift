//
//  IntelligenceComponent.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 28/01/21.
//

import Foundation
import GameplayKit

class IntelligenceComponent: GKComponent {
    var stateMachine: GKStateMachine

    init(game: Game, enemy: Entity, startingPosition origin: GKGridGraphNode) {
        let chase = EnemyChaseState(game: game, entity: enemy)
        let flee = EnemyFleeState(game: game, entity: enemy)
        let defeated = EnemyDefeatedState(game: game, entity: enemy)
        defeated.respawnPosition = origin
        let respawn = EnemyRespawnState(game: game, entity: enemy)

        self.stateMachine = GKStateMachine(states: [chase, flee, defeated, respawn])
        self.stateMachine.enter(EnemyChaseState.self)

        super.init()
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        stateMachine.update(deltaTime: seconds)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Required init?(coder aDecoder: NSCoder) not implemented for IntelligenceComponent")
    }
}
