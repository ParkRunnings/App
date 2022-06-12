//
//  MetaController.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 30/4/2022.
//

import CoreData

class MetaController: NSObject, ObservableObject {
    
    private var current: Meta!
    
    static let shared = MetaController()
    static let id = "parkrun-meta"
    
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
    @Published var event_master: String? {
        didSet {
            current.refresh(ref: &current.event_master, value: event_master)
        }
    }
    @Published var setup: Bool! {
        didSet {
            current.refresh(ref: &current.setup, value: setup)
        }
    }
    
    @Published var setup_barcode: Bool! { didSet { update_setup_complete() } }
    @Published var setup_location: Bool! { didSet { update_setup_complete() } }
    @Published var setup_home: Bool! { didSet { update_setup_complete() } }
    @Published var setup_complete: Bool!

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
        
        setup_barcode = current.runner_number != nil
        setup_location = LocationController.shared.status != .notDetermined
        setup_home = current.event_home != nil
        setup_complete = setup_barcode && setup_location && setup_home
        setup = current.setup && setup_complete
        
    }
    
    func refresh() {
        
        current = self.fetch()
        self.update()
        
    }
    
    func reset() {
        
        let context = DataController.shared.container.viewContext
        
        context.delete(current)
        refresh()
        
        current.launches += 1
        
        DataController.shared.save()
        
        print(current.created)
        
    }
    
    func complete_setup() {
        setup = true
        DataController.shared.save()
    }
    
    func update_setup_complete() {
        
        guard let setup_barcode = setup_barcode, let setup_location = setup_location, let setup_home = setup_home else { return }
        
        setup_complete = setup_barcode && setup_location && setup_home
        
    }
    
    func update_home(event: Event) {
        event_home = event.uuid
        DataController.shared.save()
        EventController.shared.current = event
        EventController.shared.update()
    }
    
    func update_runner(runner: Runner) {
        runner_number = runner.number
        DataController.shared.save()
        RunnerController.shared.current = runner
        RunnerController.shared.update()
    }
    
}
