//
//  CharacterDetailDataSourceTests.swift
//  Breaking BadTests
//
//  Created by Ivan Ugrin on W01/12/30/19.
//

@testable import Breaking_Bad
import XCTest

class CharacterDetailDataSourceTests: XCTestCase {
    var dataSource: CharacterDetailDataSource!
    var service = Fake_CharactersService()
    var fixtures = [Character]()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        service.index { characters in
            guard let characters = characters else { return }
            self.fixtures = characters
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_dataSourceHasCorrectNumberOfItemsForSections() {
        guard let character = fixtures.first else {
            XCTFail("No character fixture found.")
            return
        }

        dataSource = CharacterDetailDataSource(character: character)
        XCTAssertEqual(dataSource.numberOfItems(in: 2), character.occupation?.count ?? 0)
        XCTAssertEqual(dataSource.numberOfItems(in: 3), character.appearance?.count ?? 0)
    }

    func test_dataSourceHasCorrectOccupationForRows() {
        guard let character = fixtures.first else {
            XCTFail("No character fixture found.")
            return
        }

        dataSource = CharacterDetailDataSource(character: character)

        var index = 0
        character.occupation?.forEach {
            XCTAssertEqual(dataSource.getOccupation(for: index), $0)
            index += 1
        }
    }

    func test_dataSourceHasCorrectSeasonAppearanceForRows() {
        guard let character = fixtures.first else {
            XCTFail("No character fixture found.")
            return
        }

        dataSource = CharacterDetailDataSource(character: character)

        var index = 0
        character.appearance?.forEach {
            XCTAssertEqual(dataSource.getSeason(for: index), $0)
            index += 1
        }
    }
}
