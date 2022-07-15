//
//  DesignController.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 30/4/2022.
//

import Foundation
import SwiftUI

class DesignController: NSObject, ObservableObject {
    
    static let shared = DesignController()
    
    let watch: Watch!
    let group: WatchGroup!
    
    override init() {
        
        watch = Watch(rawValue: WKInterfaceDevice.current().screenBounds.size)!
        group = WatchGroup(watch: watch)
        
    }
    
    func size(text: TextElement) -> CGFloat {

        switch (text, group!) {
            
            case (.title, .large): return 28
            case (.title, .small): return 20
                
            case (.subtitle, .large): return 15
            case (.subtitle, .small): return 12
                
            case (.heading, .large): return 17
            case (.heading, .small): return 12
                
            case (.subheading, .large): return 15
            case (.subheading, .small): return 11
                
            case (.card_icon, .large): return 20
            case (.card_icon, .small): return 15
                
            case (.input_digit, .large): return 22
            case (.input_digit, .small): return 15
                
            case (.input_icon, .large): return 15
            case (.input_icon, .small): return 10
                
            case (.input_athlete, .large): return 18
            case (.input_athlete, .small): return 12
                
            case (.input_help, .large): return 13
            case (.input_help, .small): return 9
                
            case (.athlete_name, .large): return 18
            case (.athlete_name, .small): return 14
                
            case (.athlete_number, .large): return 12
            case (.athlete_number, .small): return 9
                
            case (.progress_detail, .large): return 12
            case (.progress_detail, .small): return 9
            
        }

    }
    
    func size(size: SizeElement) -> CGFloat {
        
        switch (size, group!) {
            
            case (.button_bottom_margin, .large): return 20
            case (.button_bottom_margin, .small): return 0
                
            case (.card_short_vertical, .large): return 14
            case (.card_short_vertical, .small): return 8
                
            case (.card_short_horizontal, .large): return 12
            case (.card_short_horizontal, .small): return 10
                
            case (.card_short_radius, .large): return 20
            case (.card_short_radius, .small): return 14
                
            case (.card_medium_height, .large): return 50
            case (.card_medium_height, .small): return 40
                
            case (.card_medium_padding, .large): return 14
            case (.card_medium_padding, .small): return 12
                
            case (.card_medium_radius, .large): return 24
            case (.card_medium_radius, .small): return 18
                
            case (.card_tall_height, .large): return 72
            case (.card_tall_height, .small): return 54
                
            case (.card_tall_radius, .large): return 24
            case (.card_tall_radius, .small): return 16
                
            case (.card_tall_padding, .large): return 14
            case (.card_tall_padding, .small): return 10
                
            case (.card_half_height, .large): return 50
            case (.card_half_height, .small): return 30
                
            case (.card_half_radius, .large): return 20
            case (.card_half_radius, .small): return 14
                
            case (.card_half_padding, .large): return 14
            case (.card_half_padding, .small): return 10
                
            case (.barcode_card_radius, .large): return 24
            case (.barcode_card_radius, .small): return 16
                
            case (.barcode_horizontal_padding, .large): return 14
            case (.barcode_horizontal_padding, .small): return 10
                
            case (.barcode_vertical_padding, .large): return 20
            case (.barcode_vertical_padding, .small): return 14
                
            case (.confirmation_blur_height, .large): return 80
            case (.confirmation_blur_height, .small): return 50
                
            case (.confirmation_over_scroll, .large): return 60
            case (.confirmation_over_scroll, .small): return 40
                
            case (.progress_circle_size, .large): return 36
            case (.progress_circle_size, .small): return 32
                
            case (.progress_circle_line, .large): return 7
            case (.progress_circle_line, .small): return 5
                
            case (.progress_time_leading, .large): return 22
            case (.progress_time_leading, .small): return 15
                
            case (.progress_distance_leading, .large): return 16
            case (.progress_distance_leading, .small): return 9
                
            case (.progress_item_spacing, .large): return 10
            case (.progress_item_spacing, .small): return 4
            
        }
        
    }
    
}
