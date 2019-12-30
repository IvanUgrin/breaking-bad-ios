//
//  CharacterTableViewCell.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/27/19.
//

import AlamofireImage
import Foundation
import UIKit

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet var imgCharacter: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblOccupation: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(_ character: Character) {
        lblName.text = character.name
        lblOccupation.text = character.occupation?.compactMap { "\($0) \(character.occupation?.last != $0 ? "," : "")" }.reduce("", +)

        imgCharacter.image = nil
        if let url = character.imageUrl {
            imgCharacter.af_setImage(withURL: url)
        }
    }

    func setup(name: String?, imageUrl: URL?) {
        lblName.text = name

        imgCharacter.image = nil
        if let imageUrl = imageUrl {
            imgCharacter.af_setImage(withURL: imageUrl)
        }
    }
}
