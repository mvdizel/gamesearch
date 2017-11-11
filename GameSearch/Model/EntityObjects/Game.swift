//
//  Game.swift
//  GameSearch
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

final class Game {
  
  // MARK: - Public Instance Attributes
  var gameId: Int
  var name: String
  var gameDescription: String?
  var imageUrl: String?
  var releaseDate: Date?
  
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
    }
  }
}


// MARK: - CustomStringConvertible
extension Game: CustomStringConvertible {
  var description: String {
    return "id: \(gameId), name: \(name), description: \(gameDescription ?? "")"
  }
}

