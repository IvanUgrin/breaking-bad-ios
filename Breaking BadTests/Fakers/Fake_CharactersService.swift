//
//  Fake_CharactersService.swift
//  Breaking BadTests
//
//  Created by Ivan Ugrin on W52/12/27/19.
//

import Foundation
@testable import Breaking_Bad

class Fake_CharactersService: CharactersService {
    override func index(seachText: String? = nil, page: Int? = nil, perPage: Int = 10, completion: @escaping BaseService.Result<Character>) {
        let json = loadJSON("characters")

        completion(json?.array?.compactMap { self.parseObject(json: $0) })
    }
}
