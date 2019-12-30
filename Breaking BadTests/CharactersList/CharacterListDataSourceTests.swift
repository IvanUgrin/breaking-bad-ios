//
//  CharacterListDataSourceTests.swift
//  Breaking BadTests
//
//  Created by Ivan Ugrin on W52/12/28/19.
//

@testable import Breaking_Bad
import XCTest

class CharacterListDataSourceTests: XCTestCase {
    var dataSource: CharacterListDataSource!
    var service = Fake_CharactersService()
    var fixtures: [Character]!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        service.index { characters in
            self.fixtures = characters
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_sectionsInOutOfBoundsSectionIsZero() {
        dataSource = CharacterListDataSource(characters: fixtures)
        XCTAssertEqual(dataSource.numberOfItemsInSection(-1), 0)
        XCTAssertEqual(dataSource.numberOfItemsInSection(1), 0)
    }

    func test_rowsInOutOfBoundsRowIsNil() {
        dataSource = CharacterListDataSource(characters: fixtures)
        XCTAssertEqual(dataSource.itemForIndexPath(-1), nil)
        XCTAssertEqual(dataSource.itemForIndexPath(fixtures.count), nil)
    }

    func test_dataSourceHasCorrectObjects() {
        dataSource = CharacterListDataSource(characters: fixtures)
        XCTAssertEqual(dataSource.characters, fixtures)
    }

    func test_dataSourceObjectsAtIndexesMatch() {
        dataSource = CharacterListDataSource(characters: fixtures)

        var index = 0
        fixtures.forEach {
            XCTAssertEqual(dataSource.itemForIndexPath(index), $0)
            index += 1
        }
    }

    func test_dataSourceFilterIsMatchingSeasons() {
        let testableFixtures = fixtures
        testableFixtures?.first?.appearance = [1000]
        testableFixtures?.last?.appearance = [1001]
        dataSource = CharacterListDataSource(characters: testableFixtures!)
        dataSource.toggleSeason(1000)
        dataSource.toggleSeason(1001)
        XCTAssertEqual(2, dataSource.numberOfItemsInSection(0))
        XCTAssertEqual(testableFixtures?.first, dataSource.itemForIndexPath(0))
        XCTAssertEqual(testableFixtures?.last, dataSource.itemForIndexPath(1))
    }

    func test_dataSourceSelectIncorrectSeason() {
        dataSource = CharacterListDataSource(characters: fixtures)
        dataSource.toggleSeason(-1)
        XCTAssertTrue(!dataSource.selectedFilters.contains(-1))
    }
}
