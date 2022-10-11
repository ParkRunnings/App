//
//  Set.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 8/10/2022.
//

import Foundation

extension NSSet {
    
  func array<T>() -> [T] {
      return self.map({ $0 as! T})
  }
    
}
