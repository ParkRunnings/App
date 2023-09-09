//
//  DesignController.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 30/4/2022.
//

import Foundation
import SwiftUI

class DesignController: NSObject, ObservableObject {
    
    static let shared = DesignController()
    
    let watch: Watch!
    let wrist: WKInterfaceDeviceWristLocation
    
    override init() {
        
        watch = Watch(rawValue: WKInterfaceDevice.current().screenBounds.size)!
        wrist = WKInterfaceDevice.current().wristLocation
        
    }
    
    func size(text: TextElement) -> CGFloat {

        switch (text, watch.group) {
            
            case (.title, .large_curved): return 28
            case (.title, .small_curved): return 24
            case (.title, .square): return 20
                
            case (.subtitle, .large_curved): return 15
            case (.subtitle, .small_curved): return 13
            case (.subtitle, .square): return 12
                
            case (.heading, .large_curved): return 17
            case (.heading, .small_curved): return 14
            case (.heading, .square): return 12
                
            case (.subheading, .large_curved): return 15
            case (.subheading, .small_curved): return 12
            case (.subheading, .square): return 11
                
            case (.card_icon, .large_curved): return 20
            case (.card_icon, .small_curved): return 17
            case (.card_icon, .square): return 15
                
            case (.input_digit, .large_curved): return 22
            case (.input_digit, .small_curved): return 18
            case (.input_digit, .square): return 15
                
            case (.input_icon, .large_curved): return 15
            case (.input_icon, .small_curved): return 12
            case (.input_icon, .square): return 10
                
            case (.input_athlete, .large_curved): return 18
            case (.input_athlete, .small_curved): return 14
            case (.input_athlete, .square): return 12
                
            case (.input_help, .large_curved): return 13
            case (.input_help, .small_curved): return 11
            case (.input_help, .square): return 9
                
            case (.athlete_name, .large_curved): return 18
            case (.athlete_name, .small_curved): return 16
            case (.athlete_name, .square): return 14
                
            case (.athlete_number, .large_curved): return 12
            case (.athlete_number, .small_curved): return 10
            case (.athlete_number, .square): return 9
                
            case (.progress_detail, .large_curved): return 12
            case (.progress_detail, .small_curved): return 10
            case (.progress_detail, .square): return 9
            
            case (.stat_header, .large_curved): return 13
            case (.stat_header, .small_curved): return 11
            case (.stat_header, .square): return 9
            
            case (.stat_icon, .large_curved): return 11
            case (.stat_icon, .small_curved): return 9
            case (.stat_icon, .square): return 8
            
            case (.stat_value, .large_curved): return 26
            case (.stat_value, .small_curved): return 26
            case (.stat_value, .square): return 18
            
            case (.stat_legend, .large_curved): return 9
            case (.stat_legend, .small_curved): return 8
            case (.stat_legend, .square): return 6
            
            case (.result_time, .large_curved): return 14
            case (.result_time, .small_curved): return 13
            case (.result_time, .square): return 11
            
        }

    }
    
    func size(size: SizeElement) -> CGFloat {
        
        switch (size, watch.group) {
            
            case (.button_bottom_margin, .large_curved): return 16
            case (.button_bottom_margin, .small_curved): return 20
            case (.button_bottom_margin, .square): return 0
                
            case (.card_short_vertical, .large_curved): return 14
            case (.card_short_vertical, .small_curved): return 10
            case (.card_short_vertical, .square): return 8
                
            case (.card_short_horizontal, .large_curved): return 12
            case (.card_short_horizontal, .small_curved): return 10
            case (.card_short_horizontal, .square): return 10
                
            case (.card_short_radius, .large_curved): return 24
            case (.card_short_radius, .small_curved): return 16
            case (.card_short_radius, .square): return 14
                
            case (.card_medium_height, .large_curved): return 50
            case (.card_medium_height, .small_curved): return 46
            case (.card_medium_height, .square): return 40
                
            case (.card_medium_padding, .large_curved): return 14
            case (.card_medium_padding, .small_curved): return 13
            case (.card_medium_padding, .square): return 12
                
            case (.card_medium_radius, .large_curved): return 24
            case (.card_medium_radius, .small_curved): return 22
            case (.card_medium_radius, .square): return 18
                
            case (.card_tall_height, .large_curved): return 60
            case (.card_tall_height, .small_curved): return 60
            case (.card_tall_height, .square): return 54
                
            case (.card_tall_radius, .large_curved): return 28
            case (.card_tall_radius, .small_curved): return 20
            case (.card_tall_radius, .square): return 16
                
            case (.card_tall_padding, .large_curved): return 16
            case (.card_tall_padding, .small_curved): return 12
            case (.card_tall_padding, .square): return 10
                
            case (.card_half_height, .large_curved): return 50
            case (.card_half_height, .small_curved): return 40
            case (.card_half_height, .square): return 30
                
            case (.card_half_radius, .large_curved): return 20
            case (.card_half_radius, .small_curved): return 16
            case (.card_half_radius, .square): return 14
                
            case (.card_half_padding, .large_curved): return 14
            case (.card_half_padding, .small_curved): return 12
            case (.card_half_padding, .square): return 10
                
            case (.barcode_card_radius, .large_curved): return 24
            case (.barcode_card_radius, .small_curved): return 22
            case (.barcode_card_radius, .square): return 16
                
            case (.barcode_horizontal_padding, .large_curved): return 14
            case (.barcode_horizontal_padding, .small_curved): return 12
            case (.barcode_horizontal_padding, .square): return 10
                
            case (.barcode_vertical_padding, .large_curved): return 20
            case (.barcode_vertical_padding, .small_curved): return 16
            case (.barcode_vertical_padding, .square): return 14
            
            case (.barcode_rotated_ratio, .large_curved): return 2.4/1
            case (.barcode_rotated_ratio, .small_curved): return 2/1
            case (.barcode_rotated_ratio, .square): return 2.4/1
            
            case (.barcode_rotated_margin, .large_curved): return 30
            case (.barcode_rotated_margin, .small_curved): return 20
            case (.barcode_rotated_margin, .square): return 10
            
            case (.barcode_rotated_bottom_padding, .large_curved): return 6
            case (.barcode_rotated_bottom_padding, .small_curved): return 0
            case (.barcode_rotated_bottom_padding, .square): return 0
                
            case (.confirmation_blur_height, .large_curved): return 80
            case (.confirmation_blur_height, .small_curved): return 60
            case (.confirmation_blur_height, .square): return 50
                
            case (.confirmation_over_scroll, .large_curved): return 60
            case (.confirmation_over_scroll, .small_curved): return 50
            case (.confirmation_over_scroll, .square): return 40
                
            case (.progress_circle_size, .large_curved): return 36
            case (.progress_circle_size, .small_curved): return 34
            case (.progress_circle_size, .square): return 32
                
            case (.progress_circle_line, .large_curved): return 7
            case (.progress_circle_line, .small_curved): return 6
            case (.progress_circle_line, .square): return 5
                
            case (.progress_time_leading, .large_curved): return 22
            case (.progress_time_leading, .small_curved): return 17
            case (.progress_time_leading, .square): return 15
                
            case (.progress_distance_leading, .large_curved): return 16
            case (.progress_distance_leading, .small_curved): return 12
            case (.progress_distance_leading, .square): return 9
                
            case (.progress_item_spacing, .large_curved): return 10
            case (.progress_item_spacing, .small_curved): return 6
            case (.progress_item_spacing, .square): return 4
            
            case (.stat_vertical_padding, .large_curved): return 14
            case (.stat_vertical_padding, .small_curved): return 12
            case (.stat_vertical_padding, .square): return 8
            
            case (.stat_horizontal_padding, .large_curved): return 13
            case (.stat_horizontal_padding, .small_curved): return 12
            case (.stat_horizontal_padding, .square): return 10
            
            case (.card_graph_height, .large_curved): return 116
            case (.card_graph_height, .small_curved): return 130
            case (.card_graph_height, .square): return 110

            case (.stat_legend_circle, .large_curved): return 8
            case (.stat_legend_circle, .small_curved): return 6
            case (.stat_legend_circle, .square): return 5

            case (.result_timeline_top_padding, .large_curved): return 40
            case (.result_timeline_top_padding, .small_curved): return 0
            case (.result_timeline_top_padding, .square): return 0
            
        }
        
    }
    
}
