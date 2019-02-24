//
//  MainViewController.swift
//  Ready
//
//  Created by Adrian Popovici on 21/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import PromiseKit
import UIKit

enum RequestState {
    case success
    case failure(message: String)

    var message: String {
        switch self {
        case .success:
            return "Success"
        case let .failure(message: message):
            return message
        }
    }
}

protocol MainViewControllerDelegate: class {
    func didSelect(repo: RepoViewModel)
    func didRefresh() -> Promise<(repos: [RepoViewModel], state: RequestState)>
}

class MainViewController: UIViewController {

    private var requestState: RequestState = .success
    private var repos: [RepoViewModel] = []

    private let refreshControl = UIRefreshControl()

    @IBOutlet private weak var reposTableView: UITableView!

    private var delegate: MainViewControllerDelegate?

    func configure(withDelegate delegate: MainViewControllerDelegate,
                   requestState: RequestState,
                   repos: [RepoViewModel]) {
        self.delegate = delegate
        self.requestState = requestState
        self.repos = repos
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        reposTableView.addSubview(refreshControl)
        refreshControl.tintColor = UIColor(red:1 , green: 0, blue: 0, alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(didRefreshTableView), for: .valueChanged)

        refreshTableView()
    }

    @objc func didRefreshTableView() {
        delegate?.didRefresh().done(on: .main) { result in
            self.repos = result.repos
            self.requestState = result.state
            self.refreshTableView()
        }.catch { error in
            self.requestState = .failure(message: error.localizedDescription)
        }.finally(on: .main) {
            self.refreshTableView()
            self.refreshControl.endRefreshing()
        }
    }

    func refreshTableView() {
        switch requestState {
        case let .failure(message: message):
            if let errorView = ErrorView.instanceFromNib(withErrorMessage: message) as? ErrorView {
                reposTableView.backgroundView = errorView
                reposTableView.separatorStyle = .none
            }
        case .success:
            reposTableView.backgroundView = nil
            reposTableView.separatorStyle = .singleLine
            reposTableView.reloadData()
        }
    }

    

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AndroidRepoCell") as? AndroidRepoCell else {
            return UITableViewCell()
        }
        cell.configure(withViewModel: repos[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(repo: repos[indexPath.row])
    }

}
