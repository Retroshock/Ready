//
//  MainCoordinator.swift
//  Ready
//
//  Created by Adrian Popovici on 23/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import PromiseKit
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
    func didRefresh() -> Promise<(repos: [RepoViewModel], state: RequestState)> {
        return Request(withBaseURL: APIPaths.baseURL,
                path: APIPaths.reposList,
                parameters: nil)
        .get()
        .map { [weak self] response in
            guard let `self` = self else { throw CommonError.selfGuardFailed }
            self.repoJSONs = response.arrayValue
            self.repoJSONs.sort { (lhs, rhs) -> Bool in
                lhs[R.string.jsonKeys.stars()].intValue < rhs[R.string.jsonKeys.stars()].intValue
            }

            self.requestState = .success

            return (repos: self.repoJSONs.map { RepoViewModel(repo: $0) }, state: .success)
        }
    }

    func didSelect(repo: RepoViewModel) {
        SVProgressHUD.show()
        if let repoDetailsViewController = R.storyboard.main.repoDetailsViewController() {
            repoDetailsViewController.configure(withRepoName: repo.name,
                                                andDelegate: self)
            self.navigationController?.show(repoDetailsViewController, sender: nil)
        }
    }

}

extension MainCoordinator: RepoDetailsViewControllerDelegate {
    func getViewModel(forName name: String) -> Promise<RepoDetailsViewModel> {
        return Request(withBaseURL: APIPaths.baseURL,
                    path: APIPaths.specificRepo(repoName: name),
                    parameters: nil)
            .get()
            .map { detailsJSON in
                RepoDetailsViewModel(repo: detailsJSON)
        }
    }

    func getReadMe(forName name: String) -> Promise<String> {
       return Request(withBaseURL: APIPaths.baseURL,
                    path: APIPaths.readmeForRepo(repoName: name),
                    parameters: nil)
            .get()
            .map { json in
                return json[R.string.jsonKeys.content()].rawString()!
        }
    }


}
