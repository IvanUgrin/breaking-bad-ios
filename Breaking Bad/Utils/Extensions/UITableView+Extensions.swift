//
//  UITableView+Extensions.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/29/19.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell(_ name: String) {
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
}
