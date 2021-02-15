//
//  AAPLFleeScene.swift
//  AgentsCatalog
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit
import GameplayKit

class AAPLFleeScene: AAPLGameScene {
  var player: AAPLAgentNode!
  var enemy: AAPLAgentNode!
  var seekGoal: GKGoal!
  var fleeGoal: GKGoal!
  var fleeing = false {
    didSet {
      // Switch between enabling flee and stop goals so that the agent stops when not fleeing.
      if fleeing {
        self.enemy.agent.behavior?.setWeight(1, for: self.fleeGoal)
        self.enemy.agent.behavior?.setWeight(0, for: self.stopGoal)
      } else {
        self.enemy.agent.behavior?.setWeight(0, for: self.fleeGoal)
        self.enemy.agent.behavior?.setWeight(1, for: self.stopGoal)
      }
    }
  }
  override var seeking: Bool {
    didSet {
      // Switch between enabling seek and stop goals so that the agent stops when not seeking.
      if seeking {
        self.player.agent.behavior?.setWeight(1, for: self.seekGoal)
        self.player.agent.behavior?.setWeight(0, for: self.stopGoal)
      } else {
        self.player.agent.behavior?.setWeight(0, for: self.seekGoal)
        self.player.agent.behavior?.setWeight(1, for: self.stopGoal)
      }
    }
  }

  override var sceneName: String {
    return "FLEEING"
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)

    // The player agent follows the tracking agent.
    self.player = AAPLAgentNode(with: self, radius: AAPLDefaultAgentRadius, position: CGPoint(x: self.frame.midX - 150, y: self.frame.midY))
    self.player.agent.behavior = GKBehavior()
    self.agentSystem.addComponent(player.agent)

    // The enemy agent flees from the player agent.
    self.enemy = AAPLAgentNode(with: self, radius: AAPLDefaultAgentRadius, position: CGPoint(x: self.frame.midX + 150, y: self.frame.midY))

    self.enemy.color = .red
    self.enemy.agent.behavior = GKBehavior()
    self.agentSystem.addComponent(self.enemy.agent)

    // Create seek and flee goals, but add them to the agents' behaviors only in -setSeeking: / -setFleeing:.
    self.seekGoal = GKGoal(toSeekAgent: self.trackingAgent)
    self.fleeGoal = GKGoal(toFleeAgent: self.player.agent)
  }

  override func update(_ currentTime: TimeInterval) {
    let distance = simd_distance(self.player.agent.position, self.enemy.agent.position)
    let maxDistance: Float = 200.00
    self.fleeing = distance < maxDistance
    super.update(currentTime)
  }
}
