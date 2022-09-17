//
//  State.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 15/8/2022.
//

import Foundation

struct MasterState: Decodable {
    
    var state: UUID
    var refreshed: String
    
}

struct EventState: Decodable {
    
    var uuid: UUID
    var event: UUID
    var course: UUID
    var refreshed: String
    
}
