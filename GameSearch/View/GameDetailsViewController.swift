//
//  DetailViewController.swift
//  GameSearch
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

class GameDetailsViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet private weak var releaseDateLabel: UILabel!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var gameImageView: UIImageView!
  @IBOutlet private weak var gameImageSpinner: UIActivityIndicatorView!
  @IBOutlet private weak var descriptionTextView: UITextView!
  
  
  // MARK: - Public Instance Attributes
  var game: Game!
  
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    clearView()
    configureView()
  }
}


// MARK: - Private Instance Methods
extension GameDetailsViewController {
  func configureView() {
    guard let game = game else { return }
    releaseDateLabel.text = game.releaseDate?.toString() ?? "unknown"
    nameLabel.text = game.name
    descriptionTextView.text = game.gameDescription ?? ""
    // @TODO: Added just for debugging
//    for _ in 0...50 {
//      descriptionTextView.text = descriptionTextView.text! + (game.gameDescription ?? "")
//    }
    gameImageSpinner.startAnimating()
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.game.downloadImage(small: false) { image in
        DispatchQueue.main.async {
          self?.gameImageView.image = image ?? #imageLiteral(resourceName: "gameplaceholder")
          self?.gameImageSpinner.stopAnimating()
        }
      }
    }
  }
  
  func clearView() {
    releaseDateLabel.text = nil
    nameLabel.text = nil
    gameImageView.image = #imageLiteral(resourceName: "gameplaceholder")
    descriptionTextView.text = ""
    gameImageSpinner.stopAnimating()
  }
}
