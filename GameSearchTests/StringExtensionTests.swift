//
//  StringExtensionTests.swift
//  GameSearchTests
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import XCTest
@testable import GameSearch

class StringExtensionTests: XCTestCase {
  
  // MARK: - Functional Tests
  func testToDate() {
    let testDate = "2001-11-15 00:00:00".toDate()
    XCTAssertNotNil(testDate)
  }
}
