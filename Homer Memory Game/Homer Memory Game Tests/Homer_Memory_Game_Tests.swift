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

    func testSuccessSound() throws {
        gameViewPresenter.playSoundNamed("successSound")
    }

    func testFailureSound() throws {
        gameViewPresenter.playSoundNamed("failureSound")
    }

    func testInvalidSound() throws {
        gameViewPresenter.playSoundNamed("Invalid")
    }

    func testCardWasSelectedMatch() throws {
        XCTAssertNil(gameViewPresenter.cardWasSelected(Cards.Bat))
        guard let wasMatch = gameViewPresenter.cardWasSelected(Cards.Bat) else {
            XCTFail()
            return
        }
        XCTAssertTrue(wasMatch)
    }

    func testCardWasSelectedNoMatch() throws {
        XCTAssertNil(gameViewPresenter.cardWasSelected(Cards.Bat))
        guard let wasMatch = gameViewPresenter.cardWasSelected(Cards.Dragon) else {
            XCTFail()
            return
        }
        XCTAssertFalse(wasMatch)
    }
}
