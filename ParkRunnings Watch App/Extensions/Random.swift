//
//  Random.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 2/11/2022.
//

import Foundation

struct RandomNumberGeneratorWithSeed: RandomNumberGenerator {
    
    init(seed: Int) {
        srand48(seed)
    }
    
    func next() -> UInt64 {
        return withUnsafeBytes(of: drand48()) { bytes in
            bytes.load(as: UInt64.self)
        }
    }
    
}
