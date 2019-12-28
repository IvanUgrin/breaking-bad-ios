//
//  CharacterListViewController.swift
//  Breaking Bad
//
//  Created by Ivan Ugrin on W52/12/27/19.
//

import UIKit

protocol CharacterListPaginator {
    func loadPage(_ page: Int)
}

class CharacterListViewController: UIViewController {
    @IBOutlet var tblCharacters: UITableView!
    var service: CharactersService?
    var dataSource = CharacterListDataSource()
    var page = 0
    static let perPage = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if service == nil {
            service = CharactersService()
            reloadData(fromStart: true)
        }
        
        tblCharacters.delegate = self
        tblCharacters.dataSource = self
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

extension CharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self), for: indexPath) as? CharacterTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self), for: indexPath)
        }
        
        let character = dataSource.itemForIndexPath(indexPath.row)
        cell.setup(character)
        
        return cell
    }
}

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dataSource.characters.count % Self.perPage > 0 {
            return
        }
        
        if indexPath.row == (dataSource.characters.count - 1) {
            reloadData(fromStart: false)
        }
    }
    
    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        
    }
}

class CharacterListDataSource: NSObject {
    var characters = [Character]()
    
    init(characters: [Character] = [Character]()) {
        self.characters = characters
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        guard section == 0 else { return 0 }
        
        return characters.count
    }

    func itemForIndexPath(_ index: Int) -> Character {
        return characters[index]
    }
}
