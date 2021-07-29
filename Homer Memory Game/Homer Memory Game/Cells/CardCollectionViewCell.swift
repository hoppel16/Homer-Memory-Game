//
//  CardCollectionViewCell.swift
//  Homer Memory Game
//
//  Created by Hunter Oppel on 7/29/21.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var textLabel: UILabel!

    var cardType: Card? {
        didSet {
            textLabel.text = cardType?.rawValue
        }
    }

    var isFlipped: Bool = false {
        didSet {
            if isFlipped {
                textLabel.textColor = .red
                self.isUserInteractionEnabled = false
            } else {
                textLabel.textColor = .black
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    var isMatched: Bool = false {
        didSet {
            if isMatched {
                textLabel.textColor = .purple
                self.isUserInteractionEnabled = false
            }
        }
    }
}
