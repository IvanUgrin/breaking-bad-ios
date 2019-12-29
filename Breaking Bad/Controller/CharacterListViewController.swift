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
    
    var service: CharactersService?
    var dataSource = CharacterListDataSource()
    let debouncer = Debouncer(seconds: 1.5)
    var page = 0
    static let perPage = 10

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
        
        tblCharacters.delegate = self
        tblCharacters.dataSource = self
        
        searchBar.delegate = self
    }
    
    private func reloadData(fromStart: Bool) {
        page = fromStart ? 0 : page + 1

        service?.index(page: page, perPage: Self.perPage, completion: { characters in
            guard let characters = characters else { return }
            if fromStart {
                self.dataSource = CharacterListDataSource()
            }
            self.dataSource.characters.append(contentsOf: characters)
            self.tblCharacters.reloadData()
        })
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

// MARK: - UITableViewDataSource
extension CharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchBar.text?.count ?? 0 > 0 || dataSource.characters.count % Self.perPage > 0 {
            return
        }
        
        if indexPath.row == (dataSource.characters.count - 1) {
            reloadData(fromStart: false)
        }
    }
    
    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        
    }
}

// MARK: - UITableViewDelegate
extension CharacterListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.debounce {
            if searchText.count > 0 {
                self.service?.index(seachText: searchText, completion: { (characters) in
                    self.dataSource = CharacterListDataSource(characters: characters ?? [])
                    self.tblCharacters.reloadData()
                })
            }
            else {
                self.reloadData(fromStart: true)
            }
        }
    }
}

// MARK: - CharacterListDataSource
class CharacterListDataSource: NSObject {
    var characters = [Character]()
    
    init(characters: [Character] = [Character]()) {
        self.characters = characters
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        guard section == 0 else { return 0 }
        
        return characters.count
    }

    func itemForIndexPath(_ index: Int) -> Character? {
        guard 0 ..< characters.count ~= index else { return nil }
        
        return characters[index]
    }
}
