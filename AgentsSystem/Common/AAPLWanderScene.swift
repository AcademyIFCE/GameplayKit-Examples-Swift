//
//  AAPLWanderScene.swift
//  AgentsCatalog
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit
import GameplayKit

class AAPLWanderScene: AAPLGameScene {
  override var sceneName: String {
    return "WANDERING"
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    let wanderer = AAPLAgentNode(with: self, radius: AAPLDefaultAgentRadius, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
    wanderer.color = .cyan
    wanderer.agent.behavior = GKBehavior(goal: GKGoal(toWander: 10), weight: 100)
    self.agentSystem.addComponent(wanderer.agent)
  }
}
