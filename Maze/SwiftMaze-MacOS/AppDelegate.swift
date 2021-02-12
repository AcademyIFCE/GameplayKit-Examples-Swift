//
//  AppDelegate.swift
//  SwiftMaze-MacOS
//
//  Created by Gabriela Bezerra on 29/01/21.
//

import Cocoa
import SpriteKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!

    private var game: Game!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the game and its SpriteKit scene.
        self.game = Game()
        let scene = self.game.scene
        scene.scaleMode = SKSceneScaleMode.aspectFit

        // Present the scene and configure the SpriteKit view.
        self.skView.presentScene(scene)
        self.skView.ignoresSiblingOrder = true
        self.skView.showsFPS = true
        self.skView.showsNodeCount = true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
