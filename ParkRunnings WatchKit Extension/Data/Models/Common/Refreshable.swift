//
//  Refreshable.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 9/6/2022.
//

import Foundation

protocol Refreshable {}

extension Refreshable {
    
    func refresh<T: Equatable>(ref: inout T, value: T) {
        if ref != value {
            ref = value
        }
    }
    
}
