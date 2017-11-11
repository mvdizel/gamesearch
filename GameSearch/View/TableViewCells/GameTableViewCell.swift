//
//  GameTableViewCell.swift
//  GameSearch
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import UIKit

final class GameTableViewCell: UITableViewCell {
  
  // MARK: - IBOutlets
  @IBOutlet private weak var gameImageView: UIImageView!
  @IBOutlet private weak var gameImageViewSpinner: UIActivityIndicatorView!
  @IBOutlet private weak var gameNameLabel: UILabel!
  @IBOutlet private weak var gameDescriptionLabel: UILabel!
  @IBOutlet private weak var gameReleaseDateLabel: UILabel!
  
  
  // MARK: - Private Instance Attributes
  private var gameImage: UIImage?
  
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    clearCell()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    clearCell()
  }
}


// MARK: - Public Instance Methods
extension GameTableViewCell {
  func configureCell(_ game: Game) {
    gameNameLabel.text = game.name
    gameDescriptionLabel.text = game.gameDescription
    gameReleaseDateLabel.text = game.releaseDate?.toString()
    gameImageViewSpinner.startAnimating()
    game.downloadImage(small: true) { [weak self] image in
      DispatchQueue.main.async {
        self?.gameImageView.image = image ?? #imageLiteral(resourceName: "gameplaceholder")
        self?.gameImageViewSpinner.stopAnimating()
      }
    }
  }
}


// MARK: - Private Instance Methods
private extension GameTableViewCell {
  func clearCell() {
    gameImageView.image = #imageLiteral(resourceName: "gameplaceholder")
    gameNameLabel.text = nil
    gameDescriptionLabel.text = nil
    gameReleaseDateLabel.text = nil
    gameImageViewSpinner.stopAnimating()
  }
}
