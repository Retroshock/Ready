//
//  AppDelegate.swift
//  Ready
//
//  Created by Adrian Popovici on 21/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application
        self.window = UIWindow(frame: UIScreen.main.bounds)

        guard let containerViewController = R.storyboard.main.containerViewController() else {
            return true
        }

        self.appCoordinator = AppCoordinator(application: application,
                                             launchOptions: launchOptions,
                                             containerViewController: containerViewController)

        self.appCoordinator.start()

        self.window?.rootViewController = containerViewController
        self.window?.makeKeyAndVisible()

        return true
    }

}

