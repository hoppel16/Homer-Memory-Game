//
//  GameViewPresenter.swift
//  Homer Memory Game
//
//  Created by Hunter Oppel on 7/29/21.
//

import Foundation

class GameViewPresenter {

    private var isGuessing = false
    private var previouslySelectedCard: Card?

    func configureCardListWithGridSize(_ gridSize: (Int, Int)) -> [Card] {
        let uniqueCardCount = (gridSize.0 * gridSize.1)/2

        var cardTypes = Card.allCases
        var cardList = [Card]()

        for _ in 0..<uniqueCardCount {
            let randomCardIndex = Int.random(in: 0..<cardTypes.count)
            let chosenCardType = cardTypes[randomCardIndex]
            cardTypes.remove(at: randomCardIndex)
            cardList += [chosenCardType, chosenCardType]
        }
        cardList.shuffle()

        return cardList
    }

    func cardWasSelected(_ selectedCard: Card) -> Bool? {
        switch isGuessing {
        case true:
            isGuessing = false
            if selectedCard == previouslySelectedCard {
                return true
            } else {
                return false
            }
        case false:
            isGuessing = true
            previouslySelectedCard = selectedCard
            return nil
        }
    }
}
