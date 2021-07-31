//
//  GameViewPresenter.swift
//  Homer Memory Game
//
//  Created by Hunter Oppel on 7/29/21.
//

import Foundation
import AVFoundation

class GameViewPresenter {

    var uniqueCardCount = 0
    var cardTypes = [Cards]()

    private var soundDelay = 0.4
    private var isGuessing = false
    private var previouslySelectedCard: Cards?
    private var player: AVAudioPlayer?

    func configureCardListWithGridSize(_ gridSize: (Int, Int)) -> [Cards] {
        let cardsRequired = gridSize.0 * gridSize.1
        uniqueCardCount = cardsRequired/2

        cardTypes = Cards.allCases
        var cardList = [Cards]()

        if uniqueCardCount > cardTypes.count {
            return []
        }

        for _ in 0..<uniqueCardCount {
            let randomCardIndex = Int.random(in: 0..<cardTypes.count)
            let chosenCardType = cardTypes[randomCardIndex]
            cardTypes.remove(at: randomCardIndex)
            cardList += [chosenCardType, chosenCardType]
        }
        if cardList.count != cardsRequired {
            let randomCardIndex = Int.random(in: 0..<Cards.allCases.count)
            let chosenCardType = Cards.allCases[randomCardIndex]
            cardList += [chosenCardType]
        }
        cardList.shuffle()

        return cardList
    }

    func cardWasSelected(_ selectedCard: Cards) -> Bool? {
        switch isGuessing {
        case true:
            isGuessing = false
            if selectedCard == previouslySelectedCard {
                DispatchQueue.main.asyncAfter(deadline: .now() + soundDelay) {
                    self.playSoundNamed("successSound")
                }
                return true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + soundDelay) {
                    self.playSoundNamed("failureSound")
                }
                return false
            }
        case false:
            isGuessing = true
            previouslySelectedCard = selectedCard
            return nil
        }
    }

    func playSoundNamed(_ soundName: String, withExtension soundExtension: String = "mp3") {
        guard let path = Bundle.main.path(forResource: soundName, ofType: soundExtension) else {
            print("Failed to load sound with name: \(soundName)")
            return
        }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
