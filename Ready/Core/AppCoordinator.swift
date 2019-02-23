//
//  AppCoordinator.swift
//  Ready
//
//  Created by Adrian Popovici on 23/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import PromiseKit
import SVProgressHUD
import SwiftyJSON
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController?

    var containerViewController: ContainerViewController!

    private var application: UIApplication?
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    func start() {
        configureSVProgressHUD()

        var mainCoordinator: MainCoordinator!

        getAllRepos().done { repos in
            let repos = repos.sorted { (lhs, rhs) -> Bool in
                lhs[R.string.jsonKeys.stars()].intValue < rhs[R.string.jsonKeys.stars()].intValue
            }
            
            mainCoordinator = MainCoordinator(withRequestState: .success,
                                              repoJSONs: repos)
        }.catch { error in
            mainCoordinator = MainCoordinator(withRequestState: .failure(message: error.localizedDescription),
                                              repoJSONs: [])
        }.finally {
            self.addChildCoordinator(childCoordinator: mainCoordinator)
            mainCoordinator.start()
            self.containerViewController.addViewControllerToContainer(mainCoordinator.navigationController!)
        }

    }

    init(application: UIApplication?,
         launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
         containerViewController: ContainerViewController) {
        self.application = application
        self.launchOptions = launchOptions
        self.containerViewController = containerViewController
    }

    func configureSVProgressHUD() {
        SVProgressHUD.setForegroundColor(UIColor(red: 255/255, green: 0, blue: 0, alpha: 1))
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
    }

    private func clearReferences() {
        application = nil
        launchOptions = nil
    }

    private func getAllRepos() -> Promise<[JSON]> {
        return Request(withBaseURL: APIPaths.baseURL,
                       path: APIPaths.reposList,
                       parameters: nil)
            .get()
            .map { response in
            return response.arrayValue
        }
    }
}
