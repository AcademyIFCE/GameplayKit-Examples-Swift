//
//  AAPLPathScene.swift
//  AgentsCatalog
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit
import GameplayKit

class AAPLPathScene: AAPLGameScene {
  override var sceneName: String {
    return "FOLLOW PATH"
  }

  override func didMove(to view: SKView) {
    super.didMove(to: view)
    let follower = AAPLAgentNode(with: self, radius: AAPLDefaultAgentRadius, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
    follower.color = .cyan

    let center = vector_float2(Float(self.frame.midX), Float(self.frame.midY))
    let points: [vector_float2] = [
      vector_float2(Float(center.x), Float(center.y) + 50),
      vector_float2(Float(center.x + 50), Float(center.y) + 150),
      vector_float2(Float(center.x + 100), Float(center.y) + 150),
      vector_float2(Float(center.x + 200), Float(center.y) + 200),
      vector_float2(Float(center.x + 350), Float(center.y) + 150),
      vector_float2(Float(center.x + 300), Float(center.y)),
      vector_float2(Float(center.x), Float(center.y) - 200),
      vector_float2(Float(center.x - 200), Float(center.y) - 100),
      vector_float2(Float(center.x - 200), Float(center.y)),
      vector_float2(Float(center.x - 100), Float(center.y) + 50)
    ]

    // Create a behavior that makes the agent follow along the path.
    let path = GKPath(points: points, radius: 10, cyclical: true)
    follower.agent.behavior = GKBehavior(goal: GKGoal(toFollow: path, maxPredictionTime: 1.5, forward: true), weight: 1)

    self.agentSystem.addComponent(follower.agent)

    // Draw the path.
    var cgPoints = [CGPoint](repeating: .zero, count: 11)
    for i in 0..<10 {
        cgPoints[i] = CGPoint(x: CGFloat(points[i].x), y: CGFloat(points[i].y))
    }
    cgPoints[10] = cgPoints[0] // Repeat the last point to create a closed path.
    let pathShape = SKShapeNode(points: &cgPoints, count: 11)
    pathShape.lineWidth = 2
    pathShape.strokeColor = .magenta
    addChild(pathShape)
  }
}
