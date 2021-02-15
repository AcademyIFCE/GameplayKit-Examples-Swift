//
//  AAPLAvoidScene.swift
//  AgentsCatalog
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit
import GameplayKit

class AAPLAvoidScene: AAPLGameScene {
  var player: AAPLAgentNode!
  var seekGoal: GKGoal!
  override var seeking: Bool {
    didSet {
      // Switch between enabling seek and stop goals so that the agent stops when not seeking.
      if seeking {
        player.agent.behavior?.setWeight(1, for: seekGoal)
        player.agent.behavior?.setWeight(0, for: stopGoal)
      } else {
        player.agent.behavior?.setWeight(0, for: seekGoal)
        player.agent.behavior?.setWeight(1, for: stopGoal)
      }
    }
  }

  override var sceneName: String {
    return "AVOID OBSTACLES"
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    // Add three obstacles in a triangle formation around the center of the scene.
    let obstacles = [
      addObstacle(
        at: CGPoint(
          x: frame.midX,
          y: frame.midY + 150)),
      addObstacle(
        at: CGPoint(
          x: frame.midX - 200,
          y: frame.midY - 150)),
      addObstacle(
        at: CGPoint(
          x: frame.midX + 200,
          y: frame.midY - 150))
    ]
    // The player agent follows the tracking agent.
    self.player = AAPLAgentNode(with: self, radius: AAPLDefaultAgentRadius, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
    self.player.agent.behavior = GKBehavior()
    self.agentSystem.addComponent(self.player.agent)

    // Create the seek goal, but add it to the behavior only in seeking didSet.
    seekGoal = GKGoal(toSeekAgent: trackingAgent)

    // Add an avoid-obstacles goal with a high weight to keep the agent from overlapping the obstacles.
    player.agent.behavior?.setWeight(100, for: GKGoal(toAvoid: obstacles, maxPredictionTime: 1))
  }


  private func addObstacle(at point: CGPoint) -> GKObstacle {
    let circleShape = SKShapeNode(circleOfRadius: CGFloat(AAPLDefaultAgentRadius))
    circleShape.lineWidth = 2.5
    circleShape.fillColor = .gray
    circleShape.strokeColor = .red
    circleShape.zPosition = 1
    circleShape.position = point
    addChild(circleShape)

    let obstacle = GKCircleObstacle(radius: Float(AAPLDefaultAgentRadius))
    obstacle.position = vector_float2(Float(point.x), Float(point.y))

    return obstacle
  }
}
