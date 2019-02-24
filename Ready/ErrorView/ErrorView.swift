//
//  ErrorView.swift
//  Ready
//
//  Created by Adrian Popovici on 24/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    private var errorMessage: String!

    @IBOutlet private weak var errorLabel: UILabel!

    static func instanceFromNib(withErrorMessage message: String) -> UIView {
        guard let view = R.nib.errorView().instantiate(withOwner: nil,
                                                       options: nil)[0] as? UIView else {
            return UIView()
        }

        (view as! ErrorView).configure(withErrorMessage: message)
        
        return view
    }

    func configure(withErrorMessage errorMessage: String) {
        self.errorMessage = errorMessage
        errorLabel.text = errorMessage
    }

}
