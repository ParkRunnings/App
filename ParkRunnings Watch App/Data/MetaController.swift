//
//  MetaController.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 30/4/2022.
//

import CoreData

class MetaController: NSObject, ObservableObject {
    
    private var current: Meta!
    
    static let shared = MetaController()
    static let id = "parkrunnings-meta"
    
    @Published var runner_number: String? {
        didSet {
            setup_barcode = runner_number != nil
            current.refresh(ref: &current.runner_number, value: runner_number)
        }
    }
    
    @Published var event_home: UUID? {
        didSet {
            setup_home = event_home != nil
            current.refresh(ref: &current.event_home, value: event_home)
        }
    }
    
    @Published var location_requested: Bool! {
        didSet {
            setup_location = current.location_requested || LocationController.shared.status != .notDetermined
            current.refresh(ref: &current.location_requested, value: location_requested)
        }
    }
    
    @Published var event_master: UUID? { didSet { current.refresh(ref: &current.event_master, value: event_master) } }
    @Published var acknowledged_version: String! { didSet { current.refresh(ref: &current.acknowledged_version, value: acknowledged_version) } }
    
    @Published var nav_setup: Bool! { didSet { current.refresh(ref: &current.setup, value: nav_setup) } }
    @Published var nav_version: Bool = false
    
    @Published var setup_barcode: Bool! { didSet { update_setup_complete() } }
    @Published var setup_location: Bool! { didSet { update_setup_complete() } }
    @Published var setup_home: Bool! { didSet { update_setup_complete() } }
    @Published var setup_complete: Bool!
    
    static var simulator: Bool! {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    override init() {
        super.init()
        refresh()
        
        current.launches += 1
        
        DataController.shared.save()
        
    }
    
    func fetch() -> Meta {
        
        let context = DataController.shared.container.viewContext
        
        let meta_request = Meta.request()
        meta_request.predicate = NSPredicate(format: "id = %@", argumentArray: [MetaController.id])
        
        if let meta = try! context.fetch(meta_request).first {
            return meta
        } else {
            let meta = Meta(context: context, id: MetaController.id)
            DataController.shared.save()
            return meta
        }
        
    }
    
    func update() {
        
        runner_number = current.runner_number
        event_home = current.event_home
        event_master = current.event_master
        location_requested = current.location_requested
        acknowledged_version = current.acknowledged_version
        
        setup_barcode = current.runner_number != nil
        setup_location = current.location_requested || LocationController.shared.status != .notDetermined
        setup_home = current.event_home != nil
        setup_complete = setup_barcode && setup_location && setup_home
        
        nav_setup = current.setup && setup_complete
        nav_version = nav_setup && Watch.app_version == VersionView.version && current.acknowledged_version != Watch.app_version
        
    }
    
    func refresh() {
        
        current = self.fetch()
        self.update()
        
    }
    
    func reset() {
        
        let context = DataController.shared.container.viewContext
        
        context.delete(current)
        
        if let current = RunnerController.shared.current {
            context.delete(current)
        }
        
        refresh()
        
        current.launches += 1
        
        DataController.shared.save()
        
    }
    
    func complete_setup() {
        nav_setup = true
        DataController.shared.save()
    }
    
    func acknowledge_version() {
        nav_version = false
        acknowledged_version = Watch.app_version
        DataController.shared.save()
    }
    
    func update_setup_complete() {
        
        guard let setup_barcode = setup_barcode, let setup_location = setup_location, let setup_home = setup_home else { return }
        
        setup_complete = setup_barcode && setup_location && setup_home
        
    }
    
    func update_home(event: Event) {
        
        event_home = event.uuid
        DataController.shared.save()
        EventController.shared.update(event: event)
        
    }
    
    func update_runner(runner: Runner) {
        
        runner_number = runner.number
        DataController.shared.save()
        RunnerController.shared.update()
        
    }
    
    func update_location_requested() {
        
        location_requested = true
        DataController.shared.save()
        
    }
    
}
