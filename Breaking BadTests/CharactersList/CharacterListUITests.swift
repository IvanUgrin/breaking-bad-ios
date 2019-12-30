//
//  CharacterListUITests.swift
//  Breaking BadTests
//
//  Created by Ivan Ugrin on W52/12/29/19.
//

@testable import Breaking_Bad
import FBSnapshotTestCase

class CharacterListUITests: FBSnapshotTestCase {
    var controller: CharacterListViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()

        guard let vc = UIStoryboard(name: "Main", bundle: Bundle(for: CharacterListViewController.self))
            .instantiateViewController(withIdentifier: String(describing: CharacterListViewController.self)) as? CharacterListViewController else {
            return XCTFail("Could not instantiate CharacterListViewController from main storyboard")
        }

        controller = vc
        controller.service = Fake_CharactersService()
        _ = controller.view
//        recordMode = true
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_viewHasCorrectLayout() {
        FBSnapshotVerifyView(controller.view)
    }
}
