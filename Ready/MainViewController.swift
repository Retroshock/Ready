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
}

class MainViewController: UIViewController {

    private var requestState: RequestState = .success
    private var repos: [RepoViewModel] = []

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
