//
//  Game.swift
//  GameSearch
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import UIKit

final class Game {
  
  // MARK: - Public Instance Attributes
  var gameId: Int
  var name: String
  var gameDescription: String?
  var imageUrl: String?
  var releaseDate: Date?
  var image: UIImage?
  var smallImageUrl: String?
  var smallImage: UIImage?
  
  
  // MARK: - Initializers
  init?(parsing json: [String: Any]) {
    guard let gameId = json["id"] as? Int,
          let name = json["name"] as? String else {
      return nil
    }
    self.name = name
    self.gameId = gameId
    gameDescription = json["deck"] as? String
    if let jsonDate = json["original_release_date"] as? String {
      releaseDate = jsonDate.toDate()
    }
    if let images = json["image"] as? [String: String] {
      imageUrl = images["original_url"]
      smallImageUrl = images["small_url"]
    }
  }
}


// MARK: - CustomStringConvertible
extension Game: CustomStringConvertible {
  var description: String {
    return "id: \(gameId), name: \(name), description: \(gameDescription ?? "")"
  }
}


// MARK: - Public Instance Methods
extension Game {
  func downloadImage(small: Bool, completion: @escaping (UIImage?) -> Void) {
    let url = small ? smallImageUrl : imageUrl
    let image = small ? smallImage : self.image
    guard image == nil, let imageUrl = url else {
      completion(image)
      return
    }
    NetworkManager.shared.getData(from: imageUrl) { [weak self] data, response, error in
      guard let data = data, error == nil, let image = UIImage(data: data) else {
        completion(self?.image)
        return
      }
      if small {
        self?.smallImage = image
      } else {
        self?.image = image
      }
      completion(image)
    }
  }
}
