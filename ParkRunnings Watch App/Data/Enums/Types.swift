//
//  Types.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 9/4/2022.
//

import Foundation
import CoreGraphics
import SwiftUI

enum InputButtonType: Int {
    case zero = 0, one, two, three, four, five, six, seven, eight, nine, delete, confirm
}

enum SetupCardType: Int, CaseIterable {
    
    case barcode = 1, location, event, complete
    
    static func all() -> Array<SetupCardType> {
        return SetupCardType.allCases.sorted(by: { $0.rawValue < $1.rawValue })
    }
    
}

enum LocationRadius: Double, CaseIterable {

    case km_3 = 3000
    case km_5 = 5000
    case km_10 = 10000
    case km_30 = 20000
    case km_50 = 50000
    
    static func ascending() -> Array<LocationRadius> {
        return LocationRadius.allCases.sorted(by: {$0.rawValue < $1.rawValue})
    }
    
}

enum TextElement {
    
    case title, subtitle, heading, subheading
    case input_digit, input_icon, input_athlete, input_help
    case athlete_name, athlete_number
    case progress_detail
    case card_icon
    case stat_header, stat_icon, stat_value, stat_legend
    case result_time
    
}

enum SizeElement {

    case button_bottom_margin
    case card_short_vertical, card_short_horizontal, card_short_radius
    case card_medium_height, card_medium_padding, card_medium_radius
    case card_tall_height, card_tall_radius, card_tall_padding
    case card_half_height, card_half_radius, card_half_padding
    case barcode_card_radius, barcode_horizontal_padding, barcode_vertical_padding, barcode_rotated_ratio, barcode_rotated_margin, barcode_rotated_bottom_padding
    case confirmation_blur_height, confirmation_over_scroll
    case progress_circle_size, progress_circle_line, progress_time_leading, progress_distance_leading, progress_item_spacing
    case stat_vertical_padding, stat_horizontal_padding, card_graph_height, stat_legend_circle
    case result_timeline_top_padding
    
}

enum ScrapeStatus {
    case scraping, completed, failed
}

enum TimelinePosition {
    
    case start, middle, end
    
    func alignment() -> Alignment {
        
        switch self {
            case .start: return .topLeading
            case .middle: return .leading
            case .end: return .bottomLeading
        }
        
    }
    
}
