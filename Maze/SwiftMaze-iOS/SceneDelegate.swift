//
//  SceneDelegate.swift
//  SwiftMaze-iOS
//
//  Created by Gabriela Bezerra on 18/01/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
            window.rootViewController = mainStoryboard.instantiateInitialViewController() as? GameViewController
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}
