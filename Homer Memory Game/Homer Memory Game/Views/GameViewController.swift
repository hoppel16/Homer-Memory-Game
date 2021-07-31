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

    private let gameViewPresenter = GameViewPresenter()
    private let failedMatchDelay = 1.0

    var gridSize: (Int, Int) = (4,4)
    var insetWidth: CGFloat = 10
    var insetHeight: CGFloat = 10

    private var cardList = [Cards]()
    private var previouslySelectedIndex: IndexPath?
    private var sectionInsets: UIEdgeInsets?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        sectionInsets = UIEdgeInsets(top: insetHeight,
                                     left: insetWidth,
                                     bottom: insetHeight,
                                     right: insetWidth)
        self.cardList = gameViewPresenter.configureCardListWithGridSize(gridSize)
        setUpView()
        setCollectionView()
    }

    // MARK: - Functions

    private func setUpView() {
        guard let backgroundArt = UIImage(named: "backgroundArt") else {
            return
        }
        self.view.backgroundColor = UIColor(patternImage: backgroundArt)
    }

    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false

        collectionView.backgroundColor = .clear
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
        cell.isFlipped.toggle()

        var previousCell = CardCollectionViewCell()
        if let previousIndex = previouslySelectedIndex,
           let previousSelectedCell = collectionView.cellForItem(at: previousIndex) as? CardCollectionViewCell {
            previousCell = previousSelectedCell
        }

        switch gameViewPresenter.cardWasSelected(cardType) {
        case true:
            cell.isMatched.toggle()
            previousCell.isMatched.toggle()
        case false:
            collectionView.isUserInteractionEnabled.toggle()
            cell.failedMatchShake()
            previousCell.failedMatchShake()
            DispatchQueue.main.asyncAfter(deadline: .now() + failedMatchDelay) {
                cell.isFlipped.toggle()
                previousCell.isFlipped.toggle()
                collectionView.isUserInteractionEnabled.toggle()
            }
        default:
            previouslySelectedIndex = indexPath
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridSize.0 * gridSize.1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCollectionViewCell else {
            // Ok for prototype but present proper error in full app.
            fatalError("Failed to set cell as CardCollectionViewCell")
        }

        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.cardType = self.cardList[indexPath.row]
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sectionInsets = sectionInsets else {
              return collectionView.contentSize
        }
        
        let paddingSpaceWidth = sectionInsets.left * CGFloat((gridSize.1))
        let availableWidth = collectionView.frame.width - paddingSpaceWidth
        let widthPerCard = availableWidth/CGFloat(gridSize.1)

        let paddingSpaceHeight = sectionInsets.top * CGFloat((gridSize.0))
        let availableHeight = collectionView.frame.height - paddingSpaceHeight
        let heightPerCard = availableHeight/CGFloat(gridSize.0)

        return CGSize(width: widthPerCard, height: heightPerCard)
    }
}
