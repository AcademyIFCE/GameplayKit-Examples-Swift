//
//  AAPLSeekScene.swift
//  AgentsCatalog
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit
import GameplayKit

class AAPLSeekScene: AAPLGameScene {
  var player: AAPLAgentNode!
  var seekGoal: GKGoal!
  override var seeking: Bool {
    didSet {
      if seeking {
        self.player.agent.behavior?.setWeight(1, for: self.seekGoal)
        self.player.agent.behavior?.setWeight(0, for: self.stopGoal)
      }
    }
  }

  override var sceneName: String {
    return "SEEKING"
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    self.player = AAPLAgentNode(with: self, radius: CGFloat(AAPLDefaultAgentRadius), position: CGPoint(x: self.frame.midX, y: self.frame.midY))
    self.player.agent.behavior = GKBehavior()
    self.agentSystem.addComponent(self.player.agent)
    self.seekGoal = GKGoal(toSeekAgent: self.trackingAgent)
  }
}
