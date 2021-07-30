//
//  GridSizeTableViewCell.swift
//  Homer Memory Game
//
//  Created by Hunter Oppel on 7/30/21.
//

import UIKit

class GridSizeTableViewCell: UITableViewCell {
    @IBOutlet var gridSizeLabel: UILabel!

    var gridSizeText: String? {
        didSet {
            setUpText()
        }
    }

    private func setUpText() {
        gridSizeLabel.textColor = .blue
        gridSizeLabel.text = gridSizeText
    }
}
