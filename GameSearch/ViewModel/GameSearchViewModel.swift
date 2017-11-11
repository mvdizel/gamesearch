//
//  GameSearchViewModel.swift
//  GameSearch
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation
import DynamicBinder

final class GameSearchViewModel {
  
  // MARK: - Public Instance Attributes
  var insertGamesAt = DynamicBinder<[Int]>([])
  var deleteGamesAt = DynamicBinder<[Int]>([])
  var startUpdating = DynamicBinder<Void>(())
  var endUpdating = DynamicBinder<Void>(())
  var searchError = DynamicBinder<String?>(nil)
  var numberOfRows: Int {
    return games.count
  }
  
  
  // MARK: - Private Instance Attributes
  private var games: [Game] = []
  private var currentPage: Int = 0
  private var currentQuery: String?
  
  
  // MARK: - Public Instance Attributes
  func searchGames(_ query: String?, forNewPage: Bool = false) {
    guard let query = query, !query.isEmpty else {
      currentQuery = nil
      self.currentPage = 0
      removeAllGames()
      return
    }
    currentQuery = query
    let currentPage = forNewPage ? self.currentPage + 1 : 1
    self.currentPage = currentPage
    NetworkManager.shared.searchGames(query, page: currentPage, success: { [weak self] games in
      guard let strongSelf = self, strongSelf.currentQuery == query else {
        return
      }
      if currentPage == strongSelf.currentPage {
        strongSelf.currentQuery = nil
      }
      strongSelf.add(games, for: currentPage)
    }, failure: { [weak self] error in
      self?.searchError.value = "No more games"
    })
  }
  
  func game(at index: Int) -> Game? {
    guard index >= 0, index < games.count else {
      return nil
    }
    return games[index]
  }
  
  
  // MARK: - Private Instance Attributes
  private func removeAllGames() {
    startUpdating.fire()
    deleteGamesAt.value = games.enumerated().map({ $0.offset })
    games = []
    endUpdating.fire()
  }
  
  private func add(_ newGames: [Game], for page: Int) {
    guard page <= 1 || !newGames.isEmpty else {
      removeAllGames()
      return
    }
    let startIndex = page <= 1 ? 0 : games.endIndex
    startUpdating.fire()
    if page <= 1, !games.isEmpty {
      deleteGamesAt.value = games.enumerated().map({ $0.offset })
      games = []
    }
    insertGamesAt.value = newGames.enumerated().map({ startIndex + $0.offset })
    games.append(contentsOf: newGames)
    endUpdating.fire()
  }
}
