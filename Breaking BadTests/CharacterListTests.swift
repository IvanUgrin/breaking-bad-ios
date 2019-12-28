//
//  CharacterListTests.swift
//  Breaking BadTests
//
//  Created by Ivan Ugrin on W52/12/28/19.
//

import XCTest
@testable import Breaking_Bad

class CharacterListTests: XCTestCase {
    var controller: CharacterListViewController!
    var tblCharacters: UITableView!
    var service = Fake_CharactersService()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        guard let vc = UIStoryboard(name: "Main", bundle: Bundle(for: CharacterListViewController.self))
            .instantiateViewController(withIdentifier: String(describing: CharacterListViewController.self)) as? CharacterListViewController else {
                return XCTFail("Could not instantiate CharacterListViewController from main storyboard")
        }

        controller = vc
        controller.service = service
        _ = controller.view
        controller.loadViewIfNeeded()
        controller.beginAppearanceTransition(true, animated: false)
        controller.endAppearanceTransition()
        tblCharacters = controller.tblCharacters
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_viewControllerHasValidDatasource() {
        XCTAssert(tblCharacters.dataSource is CharacterListViewController)
    }
    
    func test_tableViewHasCells() {
        let cell = tblCharacters.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self))
        XCTAssertNotNil(cell)
    }
}
