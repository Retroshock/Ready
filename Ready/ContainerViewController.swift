//
//  ContainerViewController.swift
//  Ready
//
//  Created by Adrian Popovici on 23/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    private var shownViewController: UIViewController?
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        if let shownViewController = shownViewController {
            containerView.addSubview(shownViewController.view)
            shownViewController.view.frame = containerView.frame
        }
    }

    func addViewControllerToContainer(_ viewController: UIViewController) {
        if let subview = shownViewController?.view {
            subview.removeFromSuperview()
        }
        shownViewController?.removeFromParent()

        self.shownViewController = viewController

        shownViewController?.willMove(toParent: self)
        self.addChild(shownViewController!)
        shownViewController?.didMove(toParent: self)

        if containerView != nil {
            containerView.addSubview(shownViewController!.view)
            shownViewController?.view.frame = containerView.frame
        }
    }

}
