//
//  Watch.swift
//  ParkRunnings Watch App
//
//  Created by Charlie on 15/10/2022.
//

import Foundation
import SwiftUI

enum Watch {
    case w38, w40, w41, w42, w44, w45, w49
}

enum WatchGroup {
    case square, large_curved, small_curved
}

extension Watch: RawRepresentable {
    
    typealias RawValue = CGSize
    
    static var os_version: Double {
        
        get {
            let os = ProcessInfo().operatingSystemVersion
            return Double(os.majorVersion) + (Double(os.minorVersion) / 10.0)
        }
        
    }
    
    static var app_version: String {
        
        get {    
            return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        }
        
    }
    
    var group: WatchGroup {
        
        get {
            
            switch self {
                
                case .w38, .w42:
                return .square
                
                case .w40, .w41:
                return .small_curved
                
                case .w44, .w45, .w49:
                return .large_curved
                
            }
            
        }
        
    }
    
    var size: CGSize {
        
        get {
            return WKInterfaceDevice.current().screenBounds.size
        }
        
    }
    
    var status_height: CGFloat {
        
        // TODO: This might be fucked in WatchOS 10
        
        get {
            
            switch self {
                case .w38: return 38
                case .w40: return 56
                case .w41: return 68
                case .w42: return 42
                case .w44: return 62
                case .w45: return 70
                case .w49: return 74
            }
            
        }
        
    }
    
    init?(rawValue: CGSize) {
        
        let sizes: Dictionary<Watch, CGSize> = [
            .w38: CGSize(width: 136.0, height: 170.0),
            .w40: CGSize(width: 162.0, height: 197.0),
            .w41: CGSize(width: 176.0, height: 215.0),
            .w42: CGSize(width: 156.0, height: 195.0),
            .w44: CGSize(width: 184.0, height: 224.0),
            .w45: CGSize(width: 198.0, height: 242.0),
            .w49: CGSize(width: 205.0, height: 251.0)
        ]
        
        // If the provided size does not match an existing size, distances will track how close each stored size is allowing for a fuzzy size match
        var distance: Dictionary<Watch, CGFloat> = [:]
        
        for (watch, size) in sizes {
            
            if rawValue.width == size.width && rawValue.height == size.height {
                self = watch
                print(watch)
                return
            } else {
                distance[watch] = (abs(rawValue.height - size.height) + abs(rawValue.width - size.width)) / 2
            }
            
        }
        
        print("Unable to find exact watch model for size w: \(rawValue.width), h: \(rawValue.height)")
        self = distance.sorted(by: { $0.value < $1.value })[0].key
        
    }

    var rawValue: CGSize {
        
        switch self {

            case .w38: return CGSize(width: 136.0, height: 170.0)
            case .w40: return CGSize(width: 162.0, height: 197.0)
            case .w41: return CGSize(width: 176.0, height: 215.0)
            case .w42: return CGSize(width: 156.0, height: 195.0)
            case .w44: return CGSize(width: 184.0, height: 224.0)
            case .w45: return CGSize(width: 198.0, height: 242.0)
            case .w49: return CGSize(width: 205.0, height: 251.0)
            
        }
        
    }
    
}


