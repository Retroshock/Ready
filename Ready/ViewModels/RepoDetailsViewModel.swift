//
//  RepoDetailsViewModel.swift
//  Ready
//
//  Created by Adrian Popovici on 23/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RepoDetailsViewModel {
    let id: String
    let name: String
    let fullName: String
    let forks: String
    let watchers: String
    let user:  String
    let link: String
    let stars: String

    init(repo: JSON) {
        id = repo[R.string.jsonKeys.id()].stringValue
        name = repo[R.string.jsonKeys.name()].stringValue
        fullName = repo[R.string.jsonKeys.full_name()].stringValue
        forks = repo[R.string.jsonKeys.forks()].stringValue
        watchers = repo[R.string.jsonKeys.watchers()].stringValue
        user = repo[R.string.jsonKeys.owner()].dictionaryValue[R.string.jsonKeys.login()]?.stringValue ?? ""
        link = repo[R.string.jsonKeys.link()].stringValue
        stars = repo[R.string.jsonKeys.stars()].stringValue
    }
}
