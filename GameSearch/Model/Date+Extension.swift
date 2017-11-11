//
//  Date+Extension.swift
//  GameSearch
//
//  Created by Vasilii Muravev on 11/11/17.
//  Copyright © 2017 Vasilii Muravev. All rights reserved.
//

import Foundation

extension Date {
  func toString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-yyyy"
    return formatter.string(from: self)
  }
}
