//
//  BaseService+Extensions.swift
//  Breaking BadTests
//
//  Created by Ivan Ugrin on W52/12/27/19.
//

@testable import Breaking_Bad
import Foundation
import SwiftyJSON

extension BaseService {
    func loadJSON(_ name: String) -> JSON? {
        let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: ".json")
        guard let dataURL = url, let data = try? Data(contentsOf: dataURL) else {
            fatalError("Couldn't read data.json file")
        }

        return try? JSON(data: data)
    }
}
