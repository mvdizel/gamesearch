//
//  NetworkManager.swift
//  GameSearch
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import Alamofire

private let baseUrl = "https://www.giantbomb.com/api/search/"
private let apiKey = "86675b4a78e57ff2405a7b68654f89ffecb8efc3"

final class NetworkManager {
  
  // MARK: - Singleton
  static let shared = NetworkManager()
  
  
  // MARK: - Initializers
  private init() {}
  
  
  // MARK: - Public Instance Methods
  func searchGames(_ query: String, page: Int, success: @escaping ([Game]) -> Void, failure: @escaping (Error?) -> Void) {
    let parameters: [String: Any] = [
      "api_key": apiKey,
      "format": "json",
      "page": page,
      "limit": "20",
      "query": query,
      "resources": "game",
      "field_list": "name,deck,id,image,original_release_date,small_url"
    ]
    let request = Alamofire.request(baseUrl, method: .get, parameters: parameters)
    request.responseJSON { (response: DataResponse<Any>) in
      debugPrint(response)
      guard response.error == nil,
            let jsonResult = response.result.value as? [String: Any],
            let gameResults = jsonResult["results"] as? [[String: Any]] else {
        failure(response.error)
        return
      }
      var games: [Game] = []
      gameResults.forEach { json in
        guard let game = Game(parsing: json) else {
          return
        }
        games.append(game)
      }
      guard !games.isEmpty else {
        failure(nil)
        return
      }
      games.forEach { debugPrint("- \($0)") }
      success(games)
    }
  }
  
  func getData(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    let url = URL(string: url)!
    URLSession.shared.dataTask(with: url) { data, response, error in
      completion(data, response, error)
    }.resume()
  }
}
