//
//  CardCollectionViewCell.swift
//  Homer Memory Game
//
//  Created by Hunter Oppel on 7/29/21.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet var uiView: UIView!

    // MARK: - Variables

    private var cardFrontView: UIImageView?
    private let cardBackView: UIImageView! = UIImageView(image: UIImage(named: "allCardBacks"))

    var cardType: Cards? {
        didSet {
            setUpView()
        }
    }

    var isFlipped: Bool = false {
        didSet {
            flipImage()
        }
    }

    var isMatched: Bool = false {
        didSet {
            if isMatched {
                self.isUserInteractionEnabled = false
            }
        }
    }

    // MARK: - Functions

    private func setUpView() {
        guard let imageName = cardType?.rawValue else {
            return
        }

        uiView.backgroundColor = .clear
        cardFrontView = UIImageView(image: UIImage(named: imageName))
        constrainIncomingViewNamed(cardBackView)
    }

    private func constrainIncomingViewNamed(_ view: UIImageView?) {
        // TODO: Find a way to save the constraints so its not recalculating them every time

        guard let view = view else { return }

        view.contentMode = .scaleAspectFit
        uiView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    private func flipImage() {
        guard let cardFrontView = cardFrontView else { return }
        if isFlipped {
            constrainIncomingViewNamed(cardFrontView)
            UIView.transition(from: cardBackView, to: cardFrontView, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
            self.isUserInteractionEnabled = false
        } else {
            constrainIncomingViewNamed(cardBackView)
            UIView.transition(from: cardFrontView, to: cardBackView, duration: 0.5, options: .transitionFlipFromLeft, completion: nil)
            self.isUserInteractionEnabled = true
        }
    }

}
