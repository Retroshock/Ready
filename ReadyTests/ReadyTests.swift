//
//  ReadyTests.swift
//  ReadyTests
//
//  Created by Adrian Popovici on 21/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import XCTest
@testable import Ready

class ReadyTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    func testReposAccess() {
        Request(withBaseURL: APIPaths.baseURL, path: APIPaths.reposList, parameters: nil)
            .get()
            .done { repos in
            if repos.array != nil {
                XCTAssertTrue(true)
            } else {
                XCTFail()
            }
        }.catch { error in
            XCTFail(error.localizedDescription)
        }
    }

    func testRepoDetails() {
        Request(withBaseURL: APIPaths.baseURL, path: APIPaths.specificRepo(repoName: "android-test"), parameters: nil).get().done { response in
            XCTAssertTrue(true)
        }.catch { error in
            XCTFail(error.localizedDescription)
        }
    }

    func testRepoReadme() {
        Request(withBaseURL: APIPaths.baseURL,
                path: APIPaths.readmeForRepo(repoName: "android-test"),
                parameters: nil)
        .get()
        .done { json in
            guard json[R.string.jsonKeys.content()].rawString() != nil else {
                XCTFail("Could not get string of readme")
                return
            }
            XCTAssertTrue(true)
        }.catch { error in
            XCTFail(error.localizedDescription)
        }
    }

}
