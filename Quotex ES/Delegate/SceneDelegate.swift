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
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")

        if hasLaunchedBefore {
            let tabbarVC = TabBarViewController()
            window?.rootViewController = UINavigationController(rootViewController: tabbarVC)
        } else {
            let quizVC = QuizViewController()
            window?.rootViewController = UINavigationController(rootViewController: quizVC)
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }

        window?.makeKeyAndVisible()
    }
}

