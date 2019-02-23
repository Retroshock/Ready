//
//  RepoDetailsViewController.swift
//  Ready
//
//  Created by Adrian Popovici on 23/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import MarkdownView
import PromiseKit
import SVProgressHUD
import UIKit

class RepoDetailsViewController: UIViewController {

    private var viewModel: RepoDetailsViewModel!
    private var name: String!

    @IBOutlet private weak var readMeView: MarkdownView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var linkLabel: UILabel!

    func configure(withRepoName repoName: String) {
        self.name = repoName
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .red

        SVProgressHUD.show()

        self.getReadMeMarkupText().map(on: .main) { [weak self] content in
            guard let `self` = self else { return }
            guard let data = Data(base64Encoded: content, options: .ignoreUnknownCharacters) else {
                print("Could not decode: \(content)")
                throw CommonErrors.cannotDecode
            }
            self.readMeView.load(markdown: String(data: data, encoding: .utf8))
            self.readMeView.isScrollEnabled = true
        }.then { [weak self] _ -> Promise<Void> in
            guard let `self` = self else { return .value(())}
            return self.getDetails()
        }.done { [weak self] _ in
            guard let `self` = self else { return }
            self.updateViews(withViewModel: self.viewModel)
        }.catch { error in
            print(error)
            self.readMeView.isHidden = true
            SVProgressHUD.dismiss()
        }.finally {
            SVProgressHUD.dismiss()
        }

    }

    private func getDetails() -> Promise<Void> {
        return Request(withBaseURL: APIPaths.baseURL,
                path: APIPaths.specificRepo(repoName: name),
                parameters: nil)
            .get()
            .done { detailsJSON in
                self.viewModel = RepoDetailsViewModel(repo: detailsJSON)
            }
    }

    private func getReadMeMarkupText() -> Promise<String> {
        return Request(withBaseURL: APIPaths.baseURL,
                       path: APIPaths.readmeForRepo(repoName: name),
                       parameters: nil)
            .get()
            .map { json in
            return json[R.string.jsonKeys.content()].rawString()!
        }
    }

    private func updateViews(withViewModel viewModel: RepoDetailsViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }

            self.nameLabel.text = viewModel.name
            self.forksLabel.text = viewModel.forks
            self.watchersLabel.text = viewModel.watchers
            self.userLabel.text = viewModel.user
            self.linkLabel.text = viewModel.link

        }
    }

}
