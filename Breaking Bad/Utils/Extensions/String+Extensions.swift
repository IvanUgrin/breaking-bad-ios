//
//  String+Extensions.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/29/19.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
}
