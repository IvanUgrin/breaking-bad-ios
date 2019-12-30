//
//  CharacterListViewController.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/27/19.
//

import UIKit

class CharacterListViewController: UIViewController {
    @IBOutlet var tblCharacters: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var service: CharactersService?
    var dataSource = CharacterListDataSource()
    let debouncer = Debouncer(seconds: 1.5)
//    var page = 0
//    static let perPage = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    private func setup() {
        if service == nil {
            service = CharactersService()
            reloadData(fromStart: true)
        }

        tblCharacters.registerCell(String(describing: CharacterTableViewCell.self))
        tblCharacters.delegate = self
        tblCharacters.dataSource = self

        searchBar.delegate = self
    }

    private func reloadData(fromStart: Bool) {
        /// Pagination implementation
//        page = fromStart ? 0 : page + 1
//
//        service?.index(page: page, perPage: Self.perPage, completion: { characters in
//            guard let characters = characters else { return }
//            if fromStart {
//                self.dataSource = CharacterListDataSource()
//            }
//            self.dataSource.characters.append(contentsOf: characters)
//            self.tblCharacters.reloadData()
//        })

        activityIndicator.startAnimating()
        service?.index(completion: { characters in
            guard let characters = characters else { return }
            if fromStart {
                self.dataSource = CharacterListDataSource()
            }
            self.dataSource.characters.append(contentsOf: characters)
            self.tblCharacters.reloadData()
            self.activityIndicator.stopAnimating()
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if
            segue.identifier == "CharacterDetail",
            let vc = segue.destination as? CharacterDetailViewController,
            let indexPath = sender as? IndexPath,
            let character = dataSource.itemForIndexPath(indexPath.row) {
            vc.setCharacter(character: character)
        }
    }

    @IBAction func onFilter(_: Any) {
        let actionController = UIAlertController(title: "Filter by season".localized(), message: nil, preferredStyle: .actionSheet)
        dataSource
            .getSeasons()
            .forEach { season in
                let selected = dataSource.selectedFilters.contains(season) ? "✅" : ""
                actionController.addAction(UIAlertAction(title: "Season".localized() + " \(season) \(selected)", style: .default, handler: { _ in
                    self.dataSource.toggleSeason(season)
                    self.tblCharacters.reloadData()
                }))
            }
        actionController.addAction(UIAlertAction(title: "Cancel".localized(), style: .destructive, handler: nil))
        present(actionController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension CharacterListViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self), for: indexPath) as? CharacterTableViewCell,
            let character = dataSource.itemForIndexPath(indexPath.row)
        else {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self), for: indexPath)
        }
        cell.setup(character)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CharacterListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if searchBar.text?.count ?? 0 > 0 || dataSource.characters.count % Self.perPage > 0 {
//            return
//        }
//
//        if indexPath.row == (dataSource.characters.count - 1) {
//            reloadData(fromStart: false)
//        }
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "CharacterDetail", sender: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension CharacterListViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        debouncer.debounce {
            if searchText.count > 0 {
                self.activityIndicator.startAnimating()
                self.service?.index(seachText: searchText, completion: { characters in
                    self.dataSource = CharacterListDataSource(characters: characters ?? [])
                    self.tblCharacters.reloadData()
                    self.activityIndicator.stopAnimating()
                })
            } else {
                self.reloadData(fromStart: true)
            }
        }
    }
}

// MARK: - CharacterListDataSource

class CharacterListDataSource: NSObject {
    var characters = [Character]()
    var filteredCharacters = [Character]()
    var selectedFilters = [Int]()

    init(characters: [Character] = [Character]()) {
        self.characters = characters
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        guard section == 0 else { return 0 }

        if selectedFilters.count > 0 {
            return filteredCharacters.count
        }

        return characters.count
    }

    func itemForIndexPath(_ index: Int) -> Character? {
        guard 0 ..< characters.count ~= index else { return nil }

        if selectedFilters.count > 0 {
            return filteredCharacters[index]
        }

        return characters[index]
    }

    func toggleSeason(_ season: Int) {
        guard getSeasons().contains(season) else { return }

        if selectedFilters.contains(season) {
            selectedFilters.removeAll(where: { $0 == season })
        } else {
            selectedFilters.append(season)
        }
        filteredCharacters = characters.filter { ($0.appearance?.contains(where: { selectedFilters.contains($0) }) ?? false) }
    }

    func getSeasons() -> [Int] {
        return characters
            .flatMap { $0.appearance ?? [] }
            .removingDuplicates()
            .sorted(by: { $0 > $1 })
    }
}
