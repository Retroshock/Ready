//
//  RepoViewModel.swift
//  Ready
//
//  Created by Adrian Popovici on 23/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RepoViewModel {
    let id: String
    let name: String
    let fullName: String
    let stars: String

    init(repo: JSON) {
        id = repo[R.string.jsonKeys.id()].stringValue
        name = repo[R.string.jsonKeys.name()].stringValue
        fullName = repo[R.string.jsonKeys.full_name()].stringValue
        stars = repo[R.string.jsonKeys.stars()].stringValue
    }
}
