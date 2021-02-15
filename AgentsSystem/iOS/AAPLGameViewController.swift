//
//  AAPLGameViewController.swift
//  AgentsCatalog-OSX
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit
import UIKit

class AAPLGameViewController: UIViewController {
  var sceneType = 0

  var allScenes = AAPLSceneType.allCases

  override func viewDidLoad() {
    super.viewDidLoad()
    // Configure the view.
    let skView = view as? SKView
    skView?.showsFPS = true
    skView?.showsNodeCount = true
    skView?.ignoresSiblingOrder = true

    // Present the scene.
    selectScene(allScenes[0])
  }

  func selectScene(_ sceneType: AAPLSceneType) {
    let scene = sceneType.scene(with: CGSize(width: 800, height: 600))
      scene.scaleMode = SKSceneScaleMode.aspectFit
      let skView = view as? SKView
      skView?.presentScene(scene)

    navigationItem.title = scene.sceneName
  }

  @IBAction func go(toPreviousScene sender: UIBarButtonItem) {
    if sceneType <= 0 {
      sceneType = allScenes.count - 1
      selectScene(allScenes[sceneType])
    } else {
      sceneType -= 1
      selectScene(allScenes[sceneType])
    }
    print(sceneType)
  }

  @IBAction func go(toNextScene sender: UIBarButtonItem) {
    if sceneType >= allScenes.count - 1 {
      sceneType = 0
      selectScene(allScenes[sceneType])
    } else {
      sceneType += 1
      selectScene(allScenes[sceneType])
    }
    print(sceneType)
  }
}
