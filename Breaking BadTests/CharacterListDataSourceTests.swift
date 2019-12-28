//
//  CharacterListDataSourceTests.swift
//  Breaking BadTests
//
//  Created by Ivan Ugrin on W52/12/28/19.
//

import XCTest
@testable import Breaking_Bad

class CharacterListDataSourceTests: XCTestCase {
    var dataSource: CharacterListDataSource!
    var service = Fake_CharactersService()
    var fixtures: [Character]!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        service.index { (characters) in
            self.fixtures = characters
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_rowsInOutOfBoundsSectionIsZero() {
        dataSource = CharacterListDataSource()
        XCTAssertEqual(dataSource.numberOfItemsInSection(-1), 0)
        XCTAssertEqual(dataSource.numberOfItemsInSection(1), 0)
    }
    
    func test_dataSourceHasCorrectObjects() {
        dataSource = CharacterListDataSource(characters: fixtures)
        XCTAssertEqual(dataSource.characters, fixtures)
    }
    
    func test_dataSourceObjectsAtIndexesMatch() {
        dataSource = CharacterListDataSource(characters: fixtures)
        
        var index = 0
        fixtures.forEach({
            XCTAssertEqual(dataSource.itemForIndexPath(index), $0)
            index += 1
        })
    }
}
