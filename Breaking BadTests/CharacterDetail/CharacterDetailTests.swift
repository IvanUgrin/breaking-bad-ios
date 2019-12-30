//
//  CharacterDetailTests.swift
//  Breaking BadTests
//
//  Created by Ivan Ugrin on W01/12/30/19.
//

@testable import Breaking_Bad
import XCTest

class CharacterDetailTests: XCTestCase {
    var controller: CharacterDetailViewController!
    var tblDetail: UITableView!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        guard let vc = UIStoryboard(name: "Main", bundle: Bundle(for: CharacterDetailViewController.self))
            .instantiateViewController(withIdentifier: String(describing: CharacterDetailViewController.self)) as? CharacterDetailViewController else {
            return XCTFail("Could not instantiate CharacterDetailViewController from main storyboard")
        }

        controller = vc
        _ = controller.view
        controller.loadViewIfNeeded()
        controller.beginAppearanceTransition(true, animated: false)
        controller.endAppearanceTransition()
        tblDetail = controller.tblDetails
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_viewControllerHasValidDatasource() {
        XCTAssert(tblDetail.dataSource is CharacterDetailViewController)
    }

    func test_tableViewHasCells() {
        var cell = tblDetail.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self))
        XCTAssertNotNil(cell)
        cell = tblDetail.dequeueReusableCell(withIdentifier: String(describing: CharacterDetailLabelTableViewCell.self))
        XCTAssertNotNil(cell)
        cell = tblDetail.dequeueReusableCell(withIdentifier: String(describing: CharacterDetailTitleAndLabelTableViewCell.self))
        XCTAssertNotNil(cell)
        cell = tblDetail.dequeueReusableCell(withIdentifier: String(describing: CharacterSectionHeaderTableViewCell.self))
        XCTAssertNotNil(cell)
    }
}
