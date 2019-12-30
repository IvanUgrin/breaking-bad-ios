//
//  CharacterDetailUITests.swift
//  Breaking BadTests
//
//  Created by Ivan Ugrin on W01/12/30/19.
//

@testable import Breaking_Bad
import FBSnapshotTestCase

class CharacterDetailUITests: FBSnapshotTestCase {
    var controller: CharacterDetailViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()

        guard let vc = UIStoryboard(name: "Main", bundle: Bundle(for: CharacterDetailViewController.self))
            .instantiateViewController(withIdentifier: String(describing: CharacterDetailViewController.self)) as? CharacterDetailViewController else {
            return XCTFail("Could not instantiate CharacterDetailViewController from main storyboard")
        }

        controller = vc
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
