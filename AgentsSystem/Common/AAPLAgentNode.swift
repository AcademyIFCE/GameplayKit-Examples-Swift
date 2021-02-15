//
//  AAPLAgentNode.swift
//  AgentsCatalog
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit
import GameplayKit

class AAPLAgentNode: SKNode, GKAgentDelegate {
  var agent = GKAgent2D()
  var color: SKColor? {
    get {
      triangleShape.strokeColor
    }
    set {
      triangleShape.strokeColor = newValue ?? .clear
    }
  }
  var drawsTrail = false {
    didSet {
      if self.drawsTrail {
          particles.particleBirthRate = defaultParticleRate
      } else {
          particles.particleBirthRate = 0
      }
    }
  }

  var triangleShape: SKShapeNode
  var particles: SKEmitterNode
  var defaultParticleRate: CGFloat = 0.0

  init(with scene: SKScene, radius: CGFloat, position: CGPoint) {
    // A triangle to represent the agent's heading (rotation) in the agent simulation.
    var points = [CGPoint]()
    let triangleBackSideAngle: Float = Float((135.0/360.0) * (2 * .pi))
    //Tip
    points.append(CGPoint(x: radius, y: 0))
    //Back Bottom
    points.append(CGPoint(x: radius * CGFloat(cos(triangleBackSideAngle)), y: radius * CGFloat(sin(triangleBackSideAngle))))
    //Back top
    points.append(CGPoint(x: radius * CGFloat(cos(triangleBackSideAngle)), y: -radius * CGFloat(sin(triangleBackSideAngle))))
    //Back top
    points.append(CGPoint(x: radius, y: 0))

    triangleShape = SKShapeNode(points: &points, count: 4)
    triangleShape.lineWidth = 2.5
    triangleShape.zPosition = 1


    // A particle effect to leave a trail behind the agent as it moves through the scene.
    particles = SKEmitterNode(fileNamed: "Trail.sks")!
    defaultParticleRate = particles.particleBirthRate
    particles.position = CGPoint(x: -radius + 5, y: 0)
    particles.targetNode = scene
    particles.zPosition = 0

    super.init()
    self.position = position
    self.zPosition = 10
    scene.addChild(self)

    agent.radius = Float(radius)
    agent.position = vector_float2(x: Float(position.x), y: Float(position.y))
    agent.delegate = self
    agent.maxSpeed = 100
    agent.maxAcceleration = 50

    // A circle to represent the agent's radius in the agent simulation.
    let circleShape = SKShapeNode(circleOfRadius: radius)
    circleShape.lineWidth = 2.5
    circleShape.fillColor = .gray
    circleShape.zPosition = 1

    //Add childs
    addChild(circleShape)
    addChild(particles)
    addChild(triangleShape)
  }

  // MARK: - GKAgentDelegate

  func agentWillUpdate(_ agent: GKAgent) {
    // All changes to agents in this app are driven by the agent system, so
    // there's no other changes to pass into the agent system in this method.
  }

  func agentDidUpdate(_ agent: GKAgent) {
    // Agent and sprite use the same coordinate system (in this app),
    // so just convert vector_float2 position to CGPoint.
    guard let agent = agent as? GKAgent2D else { return }

    self.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))
    self.zRotation = CGFloat(agent.rotation)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
