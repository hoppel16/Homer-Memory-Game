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
}
