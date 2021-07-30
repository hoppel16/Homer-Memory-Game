//
//  GameViewController.swift
//  Homer Memory Game
//
//  Created by Hunter Oppel on 7/29/21.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet var backButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!

    // MARK: - Variables

    var gridSize: (Int, Int)? = (5,2)

    private var cardList = [Card]()

    private var previouslySelectedIndex: IndexPath?
    private let gameViewPresenter = GameViewPresenter()
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let gridSize = gridSize else { return }
        self.cardList = gameViewPresenter.configureCardListWithGridSize(gridSize)
        setCollectionView()
    }

    // MARK: - Functions

    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
    }

    // MARK: - IBActions

    @IBAction func clickBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell,
              let cardType = cell.cardType else { return }
        cell.isFlipped = true

        var previousCell = CardCollectionViewCell()
        if let previousIndex = previouslySelectedIndex,
           let previousSelectedCell = collectionView.cellForItem(at: previousIndex) as? CardCollectionViewCell {
            previousCell = previousSelectedCell
        }

        switch gameViewPresenter.cardWasSelected(cardType) {
        case true:
            cell.isMatched = true
            previousCell.isMatched = true
        case false:
            cell.isFlipped = false
            previousCell.isFlipped = false
        default:
            previouslySelectedIndex = indexPath
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let gridSize = gridSize else { return 0 }
        return gridSize.0 * gridSize.1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCollectionViewCell else {
            // Im crashing here just because this is a prototype
            fatalError("Failed to set cell as CardCollectionViewCell")
        }

        cell.cardType = self.cardList[indexPath.row]
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let gridSize = gridSize else {
              return collectionView.contentSize
        }
        let paddingSpaceWidth = sectionInsets.left * CGFloat((gridSize.1))
        let availableWidth = collectionView.frame.width - paddingSpaceWidth
        let widthPerCard = availableWidth/CGFloat(gridSize.1)

        let paddingSpaceHeight = sectionInsets.top * CGFloat((gridSize.0))
        let availableHeight = collectionView.frame.height - paddingSpaceHeight
        let heightPerCard = availableHeight/CGFloat(gridSize.1)

        return CGSize(width: widthPerCard, height: heightPerCard)
    }
}
