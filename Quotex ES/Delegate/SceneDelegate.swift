//
//  SceneDelegate.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 10.12.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard (scene is UIWindowScene) else { return }

        let quizViewController = QuizViewController()
        let navigationController = UINavigationController(rootViewController: quizViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
            let tabBarViewController = TabBarViewController()
            self.window?.rootViewController = tabBarViewController
    }
}
