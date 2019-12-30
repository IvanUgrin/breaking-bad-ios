//
//  CharacterDetailLabelTableViewCell.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/29/19.
//

import UIKit

class CharacterDetailLabelTableViewCell: UITableViewCell {
    @IBOutlet var lblDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(description: String?) {
        lblDescription.text = description
    }
}
