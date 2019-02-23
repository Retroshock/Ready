//
//  AndroidRepoCell.swift
//  Ready
//
//  Created by Adrian Popovici on 21/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import UIKit

class AndroidRepoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!

    private var viewModel: RepoViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.nameLabel.text = self.viewModel.name
                self.starsLabel.text = "Stars: \(self.viewModel.stars)"
            }
        }
    }

    func configure(withViewModel viewModel: RepoViewModel) {
        self.viewModel = viewModel
    }

}
