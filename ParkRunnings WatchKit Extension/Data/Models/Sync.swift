//
//  Sync.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 1/7/2022.
//

import Foundation

enum SyncSource {
    
    case register, timer, foreground, background
    
}

enum SyncDay: Int {
    
    case sun = 1, mon, tue, wed, thu, fri, sat
    
}

struct SyncSchedule {
    
    var base: Double
    var schedule: Dictionary<SyncDay, Double>
    
    init(base base_: Double, mon: Double? = nil, tue: Double? = nil, wed: Double? = nil, thu: Double? = nil, fri: Double? = nil, sat: Double? = nil, sun: Double? = nil) {
        
        base = base_
        
        schedule = [
            .mon: mon ?? base_,
            .tue: tue ?? base_,
            .wed: wed ?? base_,
            .thu: thu ?? base_,
            .fri: fri ?? base_,
            .sat: sat ?? base_,
            .sun: sun ?? base_
        ]
        
    }
    
    func current() -> Double {
        
        guard let weekday = Calendar.current.dateComponents([.weekday], from: Date.now).weekday, let syncday = SyncDay(rawValue: weekday), let current = schedule[syncday] else {
            return base
        }
        
        return current
        
    }
    
    func ticks(frequency: Double) -> Int {
        
        return Int(ceil((current() / frequency)))
        
    }
    
    func ticks(start: Date, end: Date, frequency: Double) -> Int {
        
        return Int(round((end - start) / frequency))
        
    }
    
}

struct SyncMethod {
    
    typealias Method = () -> Void
    
    var id: String
    var method: Method
    
    var ticks: Int
    var schedule: SyncSchedule
    var frequency: Double
    var sources: Array<SyncSource>
    
    private var counter: Int = 0
    private var last: Date?
    
    init(id: String, method: @escaping Method, sources: Array<SyncSource>, schedule: SyncSchedule, frequency: Double) {
        self.id = id
        self.method = method
        self.schedule = schedule
        self.frequency = frequency
        self.sources = sources
        self.ticks = schedule.ticks(frequency: frequency)
    }
    
    private mutating func call() {
        
        print("Call: \(id)")
        
        method()
        
        counter = 0
        ticks = schedule.ticks(frequency: frequency)
        last = Date.now
    
    }
    
    mutating func call(source: SyncSource) {
        
        // Exit if the called for source is not registered as valid for this method
        if !sources.contains(source) { return }
        
        if source == .timer { counter += 1 }
        
        switch (source) {
            
            case .register:
            call()
            
            case .timer:
            if counter >= ticks { call() }
            
            case .foreground:
            if schedule.ticks(start: last ?? Date.now, end: Date.now, frequency: frequency) >= ticks { call() }
            
            case .background:
            call()
            
        }
        
    }
    
}
