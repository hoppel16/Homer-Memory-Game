//
//  LobbyViewController.swift
//  Homer Memory Game
//
//  Created by Hunter Oppel on 7/30/21.
//

import UIKit

class LobbyViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Variables

    private var grids = [Grid]()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        createGridSizes()
        setUpTableView()
    }

    // MARK: - Functions

    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
    }

    private func createGridSizes() {
        grids += [Grid(name: "3x4", size: (4,3)),
                  Grid(name: "4x4", size: (4,4)),
                  Grid(name: "4x5", size: (5,4)),
                  Grid(name: "5x2",size: (5,2))]
        tableView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GameViewSegue":
            guard let gameVC = segue.destination as? GameViewController,
                  let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let selectedGrid = grids[indexPath.row]
            gameVC.gridSize = selectedGrid.size
            gameVC.insetWidth = selectedGrid.insetWidth
            gameVC.insetHeight = selectedGrid.insetHeight
        default:
            NSLog("No segue with given identifier.")
        }
    }
}

extension LobbyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grids.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GridSizeCell", for: indexPath) as? GridSizeTableViewCell else {
            // Ok for prototype but present proper error in full app.
            fatalError("Could not set cell as GridSizeTableViewCell")
        }

        cell.gridSizeText = grids[indexPath.row].name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
