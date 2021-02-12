//
//  GameViewController.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 18/01/21.
//

import Foundation
import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet var skView: SKView!

    private var game: Game!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the game and its SpriteKit scene.
        self.game = Game()
        let scene = self.game.scene
        scene.scaleMode = SKSceneScaleMode.aspectFit

        // Present the scene and configure the SpriteKit view.
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        print("swipe LEFT")
        self.game.playerDirection = .left
    }

    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        print("swipe RIGHT")
        self.game.playerDirection = .right
    }

    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        print("swipe DOWN")
        self.game.playerDirection = .down
    }

    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        print("swipe UP")
        self.game.playerDirection = .up
    }

    @IBAction func tap(_ sender: UISwipeGestureRecognizer) {
        print("TAP")
        self.game.hasPowerup = true
    }

}
