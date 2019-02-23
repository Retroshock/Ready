//
//  APIPaths.swift
//  Ready
//
//  Created by Adrian Popovici on 23/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import Alamofire
import Foundation

struct APIPaths {
    static let baseURL = "https://api.github.com"
    static let reposList = "/orgs/android/repos"
    static func specificRepo(repoName: String) -> String {
        return "/repos/android/\(repoName)"
    }
    static func readmeForRepo(repoName: String) -> String {
        return specificRepo(repoName: repoName) + "/readme"
    }
}

struct RequestsEncoding {
    static let `default`: ParameterEncoding = URLEncoding.default
}

struct RequestsHeader {
    static let `default`: HTTPHeaders? = nil
}
