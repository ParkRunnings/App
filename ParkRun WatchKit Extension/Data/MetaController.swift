//
//  MetaController.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 30/4/2022.
//

import CoreData

class MetaController: NSObject, ObservableObject {
    
    static let shared = MetaController()
    
    static private let id = "parkrun-meta"
    private var meta: Meta
    
    @Published var setup: Bool
    @Published var setup_barcode: Bool
    @Published var setup_location: Bool
    @Published var setup_home: Bool
    
    override init() {
                
        let context = DataController.shared.container.viewContext
        
        let meta_request = Meta.request()
        meta_request.predicate = NSPredicate(format: "id = %@", argumentArray: [MetaController.id])
        
        if let saved = try! context.fetch(meta_request).first {
            self.meta = saved
            self.meta.launches += 1
        } else {
            
            self.meta = Meta(
                context: context,
                id: MetaController.id,
                setup: false,
                launches: 1,
                created: Date.now
            )
            
        }
        
        if self.meta.event_master == nil {
            
            let json = try! Data(contentsOf: Bundle.main.url(forResource: "master", withExtension: "json")!)
            
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context] = context
            
            let data = try! decoder.decode(EventMeta.self, from: json)
            self.meta.event_master = data.state
            
            print("Loaded master data from local")
            
        }
        
        let setup_barcode_ = self.meta.runner_number != nil
        let setup_location_ = LocationController.shared.status != .notDetermined
        let setup_home_ = self.meta.event_home != nil
        
        let setup_ = setup_barcode_ && setup_location_ && setup_home_
        
        if setup_ != self.meta.setup {
            self.meta.setup = setup_
        }
        
        self.setup = self.meta.setup
        self.setup_barcode = setup_barcode_
        self.setup_location = setup_location_
        self.setup_home = setup_home_
       
        DataController.shared.save()
        
    }
    
    func complete_setup() {
        
        meta.setup = true
        self.setup = self.meta.setup
        
        DataController.shared.save()
        
    }
    
    func update_home(event: Event) {
        
        self.meta.event_home = event.uuid
        self.setup_home = true
        
        DataController.shared.save()
        
    }
    
}
