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

    let gridSize = (5,2)

    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
    }

    // MARK: - Functions

    // MARK: - IBActions

    @IBAction func clickBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCollectionViewCell else {
            // Im crashing here just because this is a prototype
            fatalError("Failed to set cell as CardCollectionViewCell")
        }

        cell.cardType = Card.Horse
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //  TODO: implement this code because gridSize will be optionally and passed from lobby screen

        //  guard let gridSize = gridSize else {
        //      print("Failed to get cell size")
        //      return collectionView.contentSize
        //  }
        let paddingSpaceWidth = sectionInsets.left * CGFloat((gridSize.1) + 1)
        let availableWidth = collectionView.frame.width - paddingSpaceWidth
        let widthPerCard = availableWidth/CGFloat(gridSize.1)

        let paddingSpaceHeight = sectionInsets.top * CGFloat((gridSize.0) + 1)
        let availableHeight = collectionView.frame.height - paddingSpaceHeight
        let heightPerCard = availableHeight/CGFloat(gridSize.1)

        print("Set cell size successfully")
        return CGSize(width: widthPerCard, height: heightPerCard)
    }
}
