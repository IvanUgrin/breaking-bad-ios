//
//  CharacterDetailViewController.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/29/19.
//

import AlamofireImage
import UIKit

class CharacterDetailViewController: UIViewController {
    @IBOutlet var tblDetails: UITableView?
    var dataSource: CharacterDetailDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    func setCharacter(character: Character) {
        dataSource = CharacterDetailDataSource(character: character)
    }

    private func setup() {
        tblDetails?.registerCell(String(describing: CharacterTableViewCell.self))
        tblDetails?.delegate = self
        tblDetails?.dataSource = self
        tblDetails?.reloadData()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension CharacterDetailViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return dataSource?.numberOfSections() ?? 0
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: do {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self), for: indexPath) as? CharacterTableViewCell,
                let character = dataSource?.character
            else {
                return tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self), for: indexPath)
            }
            cell.setup(name: character.name, imageUrl: character.imageUrl)

            return cell
        }
        case 1: do {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterDetailTitleAndLabelTableViewCell.self), for: indexPath) as? CharacterDetailTitleAndLabelTableViewCell
            else {
                return tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterDetailTitleAndLabelTableViewCell.self), for: indexPath)
            }

            cell.setup(title: dataSource?.getInformationLabel(for: indexPath.row), description: dataSource?.getInformationText(for: indexPath.row))

            return cell
        }
        case 2: do {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterDetailLabelTableViewCell.self), for: indexPath) as? CharacterDetailLabelTableViewCell
            else {
                return tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterDetailLabelTableViewCell.self), for: indexPath)
            }
            cell.setup(description: dataSource?.getOccupation(for: indexPath.row))

            return cell
        }
        case 3: do {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterDetailLabelTableViewCell.self), for: indexPath) as? CharacterDetailLabelTableViewCell
            else {
                return tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterDetailLabelTableViewCell.self), for: indexPath)
            }
            cell.setup(description: "Season".localized() + " \(dataSource?.getSeason(for: indexPath.row) ?? 0)")

            return cell
        }
        default:
            break
        }

        assertionFailure("No cell could  be initialized.")
        return UITableViewCell()
    }
}

extension CharacterDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerText = dataSource?.getHeader(for: section) else {
            return nil
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterSectionHeaderTableViewCell.self)) as? CharacterSectionHeaderTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterSectionHeaderTableViewCell.self))
        }
        cell.lblTitle.text = headerText

        return cell
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else {
            return 0
        }

        return 28.5
    }
}

class CharacterDetailDataSource: NSObject {
    var character: Character!
    private static let sections = [
        "Information".localized(),
        "Occupation".localized(),
        "Appearance".localized(),
    ]
    private static let informationLabels = [
        "Nickname".localized(),
        "Birthday".localized(),
        "Status".localized(),
        "Portrayed".localized(),
        "Category".localized(),
    ]

    init(character: Character) {
        self.character = character
    }

    func numberOfSections() -> Int {
        return Self.sections.count + 1
    }

    func numberOfItems(in section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return Self.informationLabels.count
        case 2:
            return character?.occupation?.count ?? 0
        case 3:
            return character?.appearance?.count ?? 0
        default:
            return 0
        }
    }

    func getHeader(for section: Int) -> String? {
        guard 1 ..< (Self.sections.count + 1) ~= section else { return nil }

        return Self.sections[section - 1]
    }

    func getInformationLabel(for row: Int) -> String? {
        guard 0 ..< Self.informationLabels.count ~= row else { return nil }

        return Self.informationLabels[row]
    }

    func getInformationText(for row: Int) -> String? {
        switch row {
        case 0:
            return character.nickname
        case 1:
            return character.formattedDate() ?? "Unknown"
        case 2:
            return character.status
        case 3:
            return character.portrayed
        case 4:
            return character.category
        default:
            return nil
        }
    }

    func getOccupation(for row: Int) -> String? {
        guard 0 ..< (character.occupation?.count ?? 0) ~= row else { return nil }

        return character.occupation?[row]
    }

    func getSeason(for row: Int) -> Int? {
        guard 0 ..< (character.appearance?.count ?? 0) ~= row else { return nil }

        return character.appearance?[row]
    }
}
