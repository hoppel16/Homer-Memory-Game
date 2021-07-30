//
//  CardCollectionViewCell.swift
//  Homer Memory Game
//
//  Created by Hunter Oppel on 7/29/21.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!

    var cardType: Cards?

    var isFlipped: Bool = false {
        didSet {
            if isFlipped {
                guard let imageName = cardType?.rawValue else {
                    return
                }
                imageView.image = UIImage(named: imageName)
                self.isUserInteractionEnabled = false
            } else {
                imageView.image = UIImage(named: "allCardBacks")
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
