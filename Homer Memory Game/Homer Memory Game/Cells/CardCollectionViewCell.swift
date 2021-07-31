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

    private let rotationValue = 0.1
    private let flipDuration = 0.5

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
                DispatchQueue.main.asyncAfter(deadline: .now() + flipDuration) {
                    let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                    rotation.duration = 0.06
                    rotation.repeatCount = 4
                    rotation.autoreverses = true
                    rotation.fromValue = NSNumber(value: self.rotationValue)
                    rotation.toValue = NSNumber(value: -self.rotationValue)
                    self.uiView.layer.add(rotation, forKey: "position")
                }
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
            UIView.transition(from: cardBackView,
                              to: cardFrontView,
                              duration: flipDuration,
                              options: .transitionFlipFromRight,
                              completion: nil)
            self.isUserInteractionEnabled = false
        } else {
            constrainIncomingViewNamed(cardBackView)
            UIView.transition(from: cardFrontView,
                              to: cardBackView,
                              duration: flipDuration,
                              options: .transitionFlipFromLeft,
                              completion: nil)
            self.isUserInteractionEnabled = true
        }
    }

}
