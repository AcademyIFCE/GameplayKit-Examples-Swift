//
//  EnemyRespawnState.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 28/01/21.
//

import Foundation
import GameplayKit

class EnemyRespawnState: EnemyState {

    private var timeRemaining: TimeInterval = 10

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        super.isValidNextState(stateClass)
        return stateClass == EnemyChaseState.self
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        self.timeRemaining = 10

        guard let component = self.entity.component(ofType: SpriteComponent.self) else { return }
        component.pulseEffectEnabled = true
    }

    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        // Restore the sprite's original appearance.
        guard let component = self.entity.component(ofType: SpriteComponent.self) else { return }
        component.pulseEffectEnabled = false
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        self.timeRemaining -= seconds
        if self.timeRemaining < 0 {
            self.stateMachine?.enter(EnemyChaseState.self)
        }
    }

}
