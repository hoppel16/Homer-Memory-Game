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

    // Set with default values in case something goes wrong in the transition
    var gridSize: (Int, Int) = (4,4)
    var insetWidth: CGFloat = 10
    var insetHeight: CGFloat = 10

    private var cardList = [Cards]()
    private var previouslySelectedIndex: IndexPath?
    private var sectionInsets: UIEdgeInsets?
    private var currentMatches = 0
    private var matchAttempts = 0

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        sectionInsets = UIEdgeInsets(top: insetHeight,
                                     left: insetWidth,
                                     bottom: insetHeight,
                                     right: insetWidth)
        setUpCardList()
        setUpView()
        setCollectionView()
    }

    // iPads are extremely resilient to stopping their autorotate. Since it looks ok on them, I'll allow them to reset the collectionViews layout
    override open var shouldAutorotate: Bool {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return false
        case .pad:
            return true
        default:
            return false
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
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

    private func setUpCardList() {
        self.cardList = gameViewPresenter.configureCardListWithGridSize(gridSize)
        collectionView.isUserInteractionEnabled = true
        collectionView.reloadData()
    }

    private func presentWinNotification() {
        let winTitle = "You Win!"
        let winMessage = "You matched all the cards in \(matchAttempts) tries!"
        let okAction = UIAlertAction(title: "Great!", style: .cancel)
        let playAgainAction = UIAlertAction(title: "Play Again?", style: .default) { action in
            self.setUpCardList()
            self.currentMatches = 0
            self.matchAttempts = 0
        }
        presentNotification(title: winTitle, message: winMessage, actions: [okAction, playAgainAction])
    }

    private func presentNotification(title: String, message: String, actions: [UIAlertAction]?) {
        let notification = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                notification.addAction(action)
            }
        }
        present(notification, animated: true, completion: nil)
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
            currentMatches += 1
        case false:
            collectionView.isUserInteractionEnabled.toggle()
            cell.failedMatchShake()
            previousCell.failedMatchShake()
            DispatchQueue.main.asyncAfter(deadline: .now() + failedMatchDelay - 0.3) {
                cell.isFlipped.toggle()
                previousCell.isFlipped.toggle()
                collectionView.isUserInteractionEnabled.toggle()
            }
        default:
            previouslySelectedIndex = indexPath
            return
        }

        matchAttempts += 1

        if currentMatches == gameViewPresenter.uniqueCardCount {
            presentWinNotification()
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

        cell.isMatched = false
        cell.isFlipped = false

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
