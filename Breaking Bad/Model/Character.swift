//
//  Character.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/27/19.
//

import Foundation
import SwiftyJSON

class Character: ModelSerializable, Equatable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        return (
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.birthdate == rhs.birthdate &&
        lhs.occupation == rhs.occupation &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.status == rhs.status &&
        lhs.appearance == rhs.appearance &&
        lhs.nickname == rhs.nickname &&
        lhs.portrayed == rhs.portrayed &&
        lhs.category == rhs.category
        )
    }
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm-dd-yyyy"

        return dateFormatter
    }()

    var id: Int?
    var name: String?
    var birthdate: Date?
    var occupation: [String]?
    var imageUrl: URL?
    var status: String?
    var appearance: [Int]?
    var nickname: String?
    var portrayed: String?
    var category: String?

    required init(_ json: JSON) {
        id = json["char_id"].int
        name = json["name"].string
        status = json["status"].string
        nickname = json["nickname"].string
        portrayed = json["portrayed"].string
        category = json["category"].string
        occupation = json["occupation"].array?.compactMap { $0.string }
        appearance = json["appearance"].array?.compactMap { $0.int }

        if
            let urlString = json["img"].string,
            let url = URL(string: urlString) {
            imageUrl = url
        }

        if
            let birthdayString = json["birthday"].string,
            birthdayString != "Unknown",
            let date = Self.dateFormatter.date(from: birthdayString) {
            birthdate = date
        }
    }
}
