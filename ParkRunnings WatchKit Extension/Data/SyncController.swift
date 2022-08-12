//
//  SyncController.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 26/6/2022.
//

import Foundation

class SyncController: NSObject, ObservableObject {
    
    static let shared = SyncController(frequency: 30, tolerance: 5)
    
    private var store: Array<SyncMethod> = []
    private let frequency: Double
    private let tolerance: Double
    private var timer: Timer?
    
    init(frequency: Double, tolerance: Double) {
        self.frequency = frequency
        self.tolerance = tolerance
        super.init()        
    }
    
    func start() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true, block: { _ in
                self.fire(source: .timer)
            })
            timer?.tolerance = tolerance
        }
        
    }
    
    func end() {
        
        timer?.invalidate()
        timer = nil
        
    }
    
    func fire(source: SyncSource) {
        
        print("Fire: \(source)")
        
        for index in store.indices {
            store[index].call(source: source)
        }
        
    }
    
    func add(id: String, method: @escaping SyncMethod.Method, sources: Array<SyncSource>, schedule: SyncSchedule) {
        
        start()
        
        for existing in store {
            if existing.id == id {
                print("Method \(id) already registered")
                return
            }
        }
        
        var sync = SyncMethod(id: id, method: method, sources: sources, schedule: schedule, frequency: frequency)
        sync.call(source: .register)
        
        store.append(sync)
        
    }
    
}
