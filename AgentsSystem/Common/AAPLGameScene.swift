//
//  AAPLGameScene.swift
//  AgentsCatalog
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit
import GameplayKit

#if !os(iOS)
import AppKit
#endif

enum AAPLSceneType: Int, CaseIterable {
  case AAPLSceneTypeSeek = 0
  case AAPLSceneTypeWander
  case AAPLSceneTypeFlee
  case AAPLSceneTypeAvoid
  case AAPLSceneTypeSeparate
  case AAPLSceneTypeAlign
  case AAPLSceneTypeFlock
  case AAPLSceneTypePath
  
  func scene(with size: CGSize) -> AAPLGameScene {
    switch self {
      case .AAPLSceneTypeSeek:
        return AAPLSeekScene(size: size)
      case .AAPLSceneTypeWander:
        return AAPLWanderScene(size: size)
      case .AAPLSceneTypeFlee:
        return AAPLFleeScene(size: size)
      case .AAPLSceneTypeAvoid:
        return AAPLAvoidScene(size: size)
      case .AAPLSceneTypeSeparate:
        return AAPLSeparateScene(size: size)
      case .AAPLSceneTypeAlign:
        return AAPLAlignScene(size: size)
      case .AAPLSceneTypeFlock:
        return AAPLFlockScene(size: size)
      case .AAPLSceneTypePath:
        return AAPLPathScene(size: size)
    }
  }
}

let AAPLDefaultAgentRadius: CGFloat = 40.0

class AAPLGameScene: SKScene {
  var sceneName: String {
    return "Default"
  }
  var _stopGoal: GKGoal?
  var stopGoal: GKGoal {
    if _stopGoal == nil {
      _stopGoal = GKGoal(toReachTargetSpeed: 0)
    }
    return _stopGoal!
  }
  
  var agentSystem: GKComponentSystem<GKAgent2D>!
  var trackingAgent: GKAgent2D!
  var seeking = false
  var lastUpdateTime: TimeInterval = 0
  
  override func didMove(to view: SKView) {
    #if !os(iOS)
    //    let fontName = Font
    let fontName = NSFont.systemFont(ofSize: 65).fontName
    let label = SKLabelNode(fontNamed: fontName)
    label.text = self.sceneName
    label.fontSize = 65
    label.horizontalAlignmentMode = .left
    label.verticalAlignmentMode = .top
    label.position = CGPoint(x: self.frame.minX + 10, y: self.frame.minY - 46)
    self.addChild(label)
    #endif
    
    self.agentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
    self.trackingAgent = GKAgent2D()
    self.trackingAgent.position = vector_float2(x: Float(self.frame.midX), y: Float(self.frame.midY))
  }
  
  override func update(_ currentTime: TimeInterval) {
    if lastUpdateTime == 0 {
      lastUpdateTime = currentTime
    }
    let delta: Double = currentTime - lastUpdateTime
    lastUpdateTime = currentTime
    self.agentSystem.update(deltaTime: delta)
  }
  
  
  #if os(iOS)
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    seeking = true
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    seeking = false
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    seeking = false
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let position = touch.location(in: self)
    self.trackingAgent.position = vector_float2(x: Float(position.x), y: Float(position.y))
  }
  #else
  override func mouseDown(with theEvent: NSEvent) {
    seeking = true
  }
  
  override func mouseUp(with theEvent: NSEvent) {
    seeking = false
  }
  
  override func mouseDragged(with theEvent: NSEvent) {
    let position = theEvent.location(in: self)
    self.trackingAgent.position = vector_float2(x: Float(position.x), y: Float(position.y))
  }
  #endif
}
