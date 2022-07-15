//
//  Enums.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 9/4/2022.
//

import Foundation
import CoreGraphics

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
    
}

enum SizeElement {

    case button_bottom_margin
    case card_short_vertical, card_short_horizontal, card_short_radius
    case card_medium_height, card_medium_padding, card_medium_radius
    case card_tall_height, card_tall_radius, card_tall_padding
    case card_half_height, card_half_radius, card_half_padding
    case barcode_card_radius, barcode_horizontal_padding, barcode_vertical_padding
    case confirmation_blur_height, confirmation_over_scroll
    case progress_circle_size, progress_circle_line, progress_time_leading, progress_distance_leading, progress_item_spacing
    
}

enum Watch {
    case w38, w40, w41, w42, w44, w45
}

extension Watch: RawRepresentable {
    
    typealias RawValue = CGSize

    init?(rawValue: CGSize) {
        
        let sizes: Dictionary<Watch, CGSize> = [
            .w38: CGSize(width: 136, height: 170),
            .w40: CGSize(width: 162, height: 197),
            .w41: CGSize(width: 176, height: 215),
            .w42: CGSize(width: 156, height: 195),
            .w44: CGSize(width: 184, height: 224),
            .w45: CGSize(width: 198, height: 242)
        ]
        
        // If the provided size does not match an existing size, distances will track how close each stored size is allowing for a fuzzy size match
        var distance: Dictionary<Watch, CGFloat> = [:]
        
        for (watch, size) in sizes {
            
            if rawValue == size {
                self = watch
                return
            } else {
                distance[watch] = (abs(rawValue.height - size.height) + abs(rawValue.width - size.width)) / 2
            }
            
        }
        
        self = distance.sorted(by: { $0.value < $1.value })[0].key
        
    }

    var rawValue: CGSize {
        
        switch self {

            case .w38: return CGSize(width: 136, height: 170)
            case .w40: return CGSize(width: 162, height: 197)
            case .w41: return CGSize(width: 176, height: 215)
            case .w42: return CGSize(width: 156, height: 195)
            case .w44: return CGSize(width: 184, height: 224)
            case .w45: return CGSize(width: 198, height: 242)
            
        }
        
    }
    
}

enum WatchGroup {
    
    case large, small
    
    init(watch: Watch) {
        
        switch watch {
            
            case .w38, .w40, .w41, .w42:
            self = .small
            
            case .w44, .w45:
            self = .large
            
        }
        
    }
    
}
