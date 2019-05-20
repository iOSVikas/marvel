//
//  AppDelegate.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkManager.shared.set(server: .development)
        setRootViewController()
        return true
    }
    
    func setRootViewController() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = CharactersListViewController.create(storyboard: mainStoryboard)
        let navigationController = UINavigationController.init(rootViewController: rootViewController)
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.backIndicatorImage = UIImage(named: "Navigation_Back")
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}

