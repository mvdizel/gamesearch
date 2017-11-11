//
//  NetworkManagerTests.swift
//  GameSearchTests
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import XCTest
@testable import GameSearch

class NetworkManagerTests: XCTestCase {
  
  // MARK: - Functional Tests
  func testSearchGames() {
    let testExpectation = expectation(description: "Search")
    NetworkManager.shared.searchGames("Halo", page: 1, success: { games in
      XCTAssertFalse(games.isEmpty)
      testExpectation.fulfill()
    }, failure: { _ in
      XCTFail()
      testExpectation.fulfill()
    })
    waitForExpectations(timeout: 10.0, handler: nil)
  }
}
