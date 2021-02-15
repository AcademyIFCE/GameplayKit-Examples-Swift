//
//  AAPLFlockScene.swift
//  AgentsCatalog
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit
import GameplayKit

class AAPLFlockScene: AAPLGameScene {
  var flock = [AAPLAgentNode]()
  var seekGoal: GKGoal!
  override var seeking: Bool {
    didSet {
      for agent in self.agentSystem.components {
        if seeking {
          agent.behavior?.setWeight(1, for: self.seekGoal)
        } else {
          agent.behavior?.setWeight(0, for: self.seekGoal)
        }
      }
    }
  }

  override var sceneName: String {
    return "FLOCKING"
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)

    var agents = [GKAgent2D]()
    let agentsPerRow = 4
    for i in 0..<(agentsPerRow * agentsPerRow) {
      let x = frame.midX + CGFloat(i % agentsPerRow * 20)
      let y = frame.midY + CGFloat(i / agentsPerRow * 20)
      let boid = AAPLAgentNode(
        with: self,
        radius: 10,
        position: CGPoint(x: x, y: y))
      agentSystem.addComponent(boid.agent)
      agents.append(boid.agent)
      flock.append(boid)
      boid.drawsTrail = false
    }

    let separationRadius: Float = 0.553 * 50
    let separationAngle: Float = 3 * .pi / 4.0
    let separationWeight: Float = 10.0
    let alignmentRadius: Float = 0.83333 * 50
    let alignmentAngle: Float = .pi / 4.0
    let alignmentWeight: Float = 12.66

    let cohesionRadius: Float = 1.0 * 100
    let cohesionAngle: Float = .pi / 2.0
    let cohesionWeight: Float = 8.66

    // Separation, alignment, and cohesion goals combined cause the flock to move as a group.
    let behavior = GKBehavior()
    behavior.setWeight(separationWeight, for: GKGoal(toSeparateFrom: agents, maxDistance: separationRadius, maxAngle: separationAngle))
    behavior.setWeight(alignmentWeight, for: GKGoal(toAlignWith: agents, maxDistance: alignmentRadius, maxAngle: alignmentAngle))
    behavior.setWeight(cohesionWeight, for: GKGoal(toCohereWith: agents, maxDistance: cohesionRadius, maxAngle: cohesionAngle))
    for agent in agents {
      agent.behavior = behavior
    }

    self.seekGoal = GKGoal(toSeekAgent: self.trackingAgent)
  }
}
