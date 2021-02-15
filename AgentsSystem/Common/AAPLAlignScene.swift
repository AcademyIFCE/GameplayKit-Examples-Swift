//
//  AAPLAlignScene.swift
//  AgentsCatalog
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit
import GameplayKit

class AAPLAlignScene: AAPLGameScene {
  var player: AAPLAgentNode!
  var friends: [AAPLAgentNode]!
  var alignGoal: GKGoal!
  var seekGoal: GKGoal!
  override var seeking: Bool {
    didSet {
      for agent in self.agentSystem.components {
        if seeking {
          agent.behavior?.setWeight(1, for: seekGoal)
          agent.behavior?.setWeight(0, for: stopGoal)
        } else {
          agent.behavior?.setWeight(0, for: seekGoal)
          agent.behavior?.setWeight(1, for: stopGoal)
        }
      }
    }
  }

  override var sceneName: String {
    return "ALIGNMENT"
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    // The player agent follows the tracking agent.
    self.player = AAPLAgentNode(with: self, radius: AAPLDefaultAgentRadius, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
    self.player.agent.behavior = GKBehavior()
    self.agentSystem.addComponent(self.player.agent)

    // Create the seek goal, but add it to the behavior only in -setSeeking:.
    self.seekGoal = GKGoal(toSeekAgent: self.trackingAgent)
    // The friend agents attempt to maintain consistent direction with the player agent.
    self.alignGoal = GKGoal(toAlignWith: [self.player.agent], maxDistance: 100, maxAngle: .pi * 2)

    self.friends = [
      addFriendAtPoint(CGPoint(x: self.frame.midX - 150 , y: self.frame.midY)),
      addFriendAtPoint(CGPoint(x: self.frame.midX + 150 , y: self.frame.midY))
    ]
    let behavior = GKBehavior(goal: self.alignGoal, weight: 100)
    for friend in friends {
      friend.agent.behavior = behavior
    }
  }


  func addFriendAtPoint(_ point: CGPoint) -> AAPLAgentNode {
    let friend = AAPLAgentNode(with: self, radius: AAPLDefaultAgentRadius, position: point)
    friend.color = .cyan
    self.agentSystem.addComponent(friend.agent)
    return friend
  }
}
