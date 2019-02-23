//
//  MainCoordinator.swift
//  Ready
//
//  Created by Adrian Popovici on 23/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import SVProgressHUD
import SwiftyJSON
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController?

    private var requestState: RequestState

    private var repoJSONs: [JSON] = []

    func start() {
        if let mainViewController = R.storyboard.main.mainViewController() {
            mainViewController.configure(withDelegate: self,
                                         requestState: requestState,
                                         repos: repoJSONs.map { RepoViewModel(repo: $0) })

            navigationController?.setViewControllers([mainViewController],
                                                     animated: true)
        }
    }

    init(withRequestState requestState: RequestState,
         repoJSONs: [JSON]) {
        self.repoJSONs = repoJSONs
        self.requestState = requestState
        navigationController = R.storyboard.main.mainNavigationController()
    }

}

extension MainCoordinator: MainViewControllerDelegate {
    func didSelect(repo: RepoViewModel) {
        SVProgressHUD.show()
        if let repoDetailsViewController = R.storyboard.main.repoDetailsViewController() {
            repoDetailsViewController.configure(withRepoName: repo.name)
            self.navigationController?.show(repoDetailsViewController, sender: nil)
        }
    }

}
