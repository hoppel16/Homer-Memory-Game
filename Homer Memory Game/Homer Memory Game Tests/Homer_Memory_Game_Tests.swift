//
//  Homer_Memory_Game_Tests.swift
//  Homer Memory Game Tests
//
//  Created by Hunter Oppel on 7/31/21.
//

import XCTest
@testable import Homer_Memory_Game

class Homer_Memory_Game_Tests: XCTestCase {

    var gameViewPresenter: GameViewPresenter!

    override func setUpWithError() throws {
        gameViewPresenter = GameViewPresenter()
    }

    func testConfigureCardListWithGridSize() throws {
        let returnedCards = gameViewPresenter.configureCardListWithGridSize((4,4))

        XCTAssertTrue(gameViewPresenter.uniqueCardCount == 8)
        XCTAssertTrue(returnedCards.count == 16)
    }

    func testConfigureCardListWithGridSizeOdd() {
        let returnedCards = gameViewPresenter.configureCardListWithGridSize((3,3))

        XCTAssertTrue(gameViewPresenter.uniqueCardCount == 4)
        XCTAssertTrue(returnedCards.count == 9)
    }

    func testConfigureCardListWithGridSizeToBig() throws {
        let returnedCards = gameViewPresenter.configureCardListWithGridSize((7, 8))

        XCTAssertTrue(gameViewPresenter.uniqueCardCount == 28)
        XCTAssertTrue(returnedCards.count == 0)
    }
}
