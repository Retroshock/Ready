//
//  GetRequest.swift
//  Ready
//
//  Created by Adrian Popovici on 23/02/2019.
//  Copyright © 2019 m.ready. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit
import SwiftyJSON

class Request {
    private let baseURL: String
    private let path: String
    private let parameters: Parameters?
    private let encoding: ParameterEncoding
    private let headers: HTTPHeaders?

    enum RequestError: Error {
        case notJSONFormat
    }

    init(withBaseURL baseURL: String,
         path: String,
         parameters: Parameters?,
         headers: HTTPHeaders? = nil,
         encoding: ParameterEncoding = RequestsEncoding.default) {
        self.baseURL = baseURL
        self.path = path
        self.parameters = parameters
        self.headers = headers
        self.encoding = encoding
    }

    func get() -> Promise<JSON> {
        return Alamofire.request(baseURL + path,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: encoding,
                                 headers: nil)
            .responseJSON().map { (arg) -> JSON in
                let (json, response) = arg
                if let data = response.data {
                    let json = try JSON(data: data)
                    return json
                } else {
                    throw RequestError.notJSONFormat
                }
        }
    }
}
