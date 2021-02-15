//
//  AAPLAppDelegate.swift
//  AgentsCatalog-OSX
//
//  Created by Yuri on 27/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import SpriteKit

import AppKit

class AAPLAppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet var skView: SKView!
  @IBOutlet var sceneControl: NSSegmentedControl!
  var window: NSWindow?

  func applicationDidFinishLaunching(_ notification: Notification) {

    window?.titleVisibility = NSWindow.TitleVisibility.hidden

    // Configure the view.
    skView.ignoresSiblingOrder = true
    skView.showsFPS = true
    skView.showsNodeCount = true

    // Present the scene.
    selectScene(sceneControl)
  }

  @IBAction func selectScene(_ sender: NSSegmentedControl) {
    let sceneType = AAPLSceneType(rawValue: sender.selectedSegment)
    let scene = sceneType?.scene(with: CGSize(width: 800, height: 600))

    scene!.scaleMode = SKSceneScaleMode.aspectFit

    skView.presentScene(scene)
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
