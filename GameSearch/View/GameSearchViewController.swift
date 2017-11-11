//
//  MasterViewController.swift
//  GameSearch
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit
import SVProgressHUD

class GameSearchViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet private weak var searchTextField: UITextField!
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet weak var noResultsLabel: UILabel!
  
  
  // MARK: - Private Instance Atrributes
  private var detailViewController: GameDetailsViewController? = nil
  private var objects = [Any]()
  private var viewModel = GameSearchViewModel()
  
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    if let split = splitViewController {
       let controllers = split.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? GameDetailsViewController
    }
    setup()
  }
  
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetailsSegue" {
      guard let indexPath = tableView.indexPathForSelectedRow,
        let game = viewModel.game(at: indexPath.row),
        let controller = (segue.destination as! UINavigationController).topViewController as? GameDetailsViewController else {
          return
      }
      controller.game = game
      controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
      controller.navigationItem.leftItemsSupplementBackButton = true
    }
  }
}


// MARK: - IBActions
extension GameSearchViewController {
  @IBAction func searchQueryChanged(_ sender: UITextField) {
    SVProgressHUD.show()
    viewModel.searchGames(sender.text)
  }
}


// MARK: - UITextFieldDelegate
extension GameSearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

// MARK: - UITableViewDataSource
extension GameSearchViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as? GameTableViewCell,
          let game = viewModel.game(at: indexPath.row) else {
      return UITableViewCell()
    }
    cell.configureCell(game)
    return cell
  }
}


// MARK: - UITableViewDelegate
extension GameSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return false
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard indexPath.row == viewModel.numberOfRows - 2 else { return }
    SVProgressHUD.show()
    viewModel.searchGames(searchTextField.text, forNewPage: true)
  }
}


// MARK: - Private Instance Methods
private extension GameSearchViewController {
  func setup() {
    noResultsLabel.isHidden = true
    tableView.keyboardDismissMode = .onDrag
    viewModel.startUpdating.bind(with: self) { [weak self] _ in
      self?.tableView.beginUpdates()
    }
    viewModel.insertGamesAt.bind(with: self) { [weak self] indexes in
      DispatchQueue.main.async {
        guard let tableView = self?.tableView, !indexes.isEmpty else { return }
        let indexPaths = indexes.map { IndexPath(row: $0, section: 0) }
        tableView.insertRows(at: indexPaths, with: .fade)
      }
    }
    viewModel.deleteGamesAt.bind(with: self) { [weak self] indexes in
      DispatchQueue.main.async {
        guard let tableView = self?.tableView, !indexes.isEmpty else { return }
        let indexPaths = indexes.map { IndexPath(row: $0, section: 0) }
        tableView.deleteRows(at: indexPaths, with: .fade)
      }
    }
    viewModel.endUpdating.bind(with: self) { [weak self] _ in
      DispatchQueue.main.async {
        self?.tableView.endUpdates()
        self?.showNoResultsLabel()
        SVProgressHUD.dismiss()
      }
    }
    viewModel.searchError.bind(with: self) { [weak self] error in
      DispatchQueue.main.async {
        self?.showNoResultsLabel()
        SVProgressHUD.dismiss()
      }
    }
    viewModel.noMoreGames.bind(with: self) { [weak self] _ in
      DispatchQueue.main.async {
        self?.showNoResultsLabel()
        SVProgressHUD.dismiss()
      }
    }
  }
  
  func showNoResultsLabel() {
    noResultsLabel.isHidden = (viewModel.numberOfRows > 0)
  }
}
