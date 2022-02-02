//
//  Array+Helpers.swift
//  Web
//
//  Created by Saqib Omer on 30/01/2022.
//

import Foundation

extension Array {
  subscript (safe index: Index) -> Iterator.Element? {
    get {
      (startIndex <= index && index < endIndex) ? self[index] : nil
    }
    
    set {
      guard startIndex <= index && index < endIndex, let newValue = newValue else { return }
      self[index] = newValue
    }
  }
}
