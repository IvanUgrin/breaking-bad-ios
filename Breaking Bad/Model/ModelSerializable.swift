//
//  ModelSerializable.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/27/25/19.
//

import Foundation
import SwiftyJSON

protocol ModelSerializable: class {
    init(_ json: JSON)
}
