//
//  CardCollectionViewCell.swift
//  Homer Memory Game
//
//  Created by Hunter Oppel on 7/29/21.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    var cardType: Card?

    var isFlipped: Bool = false {
        didSet {
            if isFlipped {
                self.isUserInteractionEnabled = false
            } else {
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    var isMatched: Bool = false {
        didSet {
            if isMatched {
                self.isUserInteractionEnabled = false
            }
        }
    }
}
