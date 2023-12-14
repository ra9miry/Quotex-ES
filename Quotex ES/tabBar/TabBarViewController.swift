//
//  TabBarViewController.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 08.12.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    private let selectedControllerKey = "SelectedControllerIndex"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        navigationItem.hidesBackButton = true
        
        self.selectedIndex = 0
        UserDefaults.standard.setValue(0, forKey: selectedControllerKey)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tabBar.frame.size.height = 100
        tabBar.layer.cornerRadius = 20
        tabBar.frame.origin.y = view.frame.height - tabBar.frame.height
    }
    
    func navigateToTab(at index: Int) {
        if index >= 0 && index < viewControllers?.count ?? 0 {
            selectedIndex = index

            UserDefaults.standard.setValue(selectedIndex, forKey: selectedControllerKey)
        }
    }

    // MARK: - setupTabBar
    
    private func setupTabBar() {
        viewControllers = [
            mainViewController(viewController: PortfolioViewController(), title: "Portfolio", image: UIImage(named: "portfolio")),
            mainViewController(viewController: StatisticsViewController(), title: "Statistics", image: UIImage(named: "stat")),
            mainViewController(viewController: SettingsViewController(), title: "Settings", image:UIImage(named: "settings")),
            mainViewController(viewController: InfoViewController(), title: "Info", image:UIImage(named: "info"))
        ]

        tabBar.barTintColor = UIColor(named: "tabbar")
        tabBar.backgroundColor = UIColor(named: "tabbar")

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func mainViewController(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image?.withRenderingMode(.alwaysTemplate)
        viewController.tabBarItem.selectedImage = image?.withTintColor(.systemBlue)
        let inset: CGFloat = 6
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: inset, left: 0, bottom: -inset, right: 0)
        viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -inset)

        return viewController
    }
}
