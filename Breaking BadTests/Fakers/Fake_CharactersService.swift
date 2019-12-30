//
//  Fake_CharactersService.swift
//  Breaking BadTests
//
//  Created by Ivan Ugrin on W52/12/27/19.
//

@testable import Breaking_Bad
import Foundation

class Fake_CharactersService: CharactersService {
    override func index(seachText _: String? = nil, page _: Int? = nil, perPage _: Int = 10, completion: @escaping BaseService.Result<Character>) {
        let json = loadJSON("characters")

        completion(json?.array?.compactMap { self.parseObject(json: $0) })
    }
}
