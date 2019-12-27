//
//  Constants.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/27/19.
//

import Foundation

struct Networking {
    static var headerFields = ["Accept": "application/json"]
    static var baseUrl = "https://breakingbadapi.com/api/"

    enum Endpoints: String {
        case characters
    }
}
