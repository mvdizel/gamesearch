//
//  DateExtensionTests.swift
//  GameSearchTests
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import XCTest
@testable import GameSearch

class DateExtensionTests: XCTestCase {
  
  // MARK: - Functional Tests
  func testToDate() {
    XCTAssertNotNil(Date().toString())
  }
}
