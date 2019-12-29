//
//  CharactersService.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/27/19.
//

class CharactersService: BaseService {
    func index(seachText: String? = nil, page: Int? = nil, perPage: Int = 10, completion: @escaping Result<Character>) {
        var parameters = Parameters()

        if let searchText = seachText {
            /// From BB api docs: Notice the 'plus sign' between the first and last name represents a space.
            parameters["name"] = searchText.replacingOccurrences(of: " ", with: "+")
        } else if let page = page {
            parameters["limit"] = perPage
            parameters["offset"] = page * perPage
        }

        request(.characters, parameters: parameters) { json in
            completion(json?.array?.compactMap { self.parseObject(json: $0) })
        }
    }
}
