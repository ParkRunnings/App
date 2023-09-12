//
//  MapView.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 12/6/2022.
//

import SwiftUI
import MapKit
import Combine

struct DragAxis {
    
    var previous: CGFloat
    var current: CGFloat
   
    func constrain(absolute: CGFloat) -> CGFloat {
        
        if current >= 0 {
            return min(current, absolute)
        } else {
            return max(current, -absolute)
        }
       
    }
    
    mutating func update(gesture: CGFloat, scale: CGFloat, absolute: CGFloat) {
        
        let new = current + (gesture - previous) / scale
        
        if current >= 0 {
            
            if current > absolute {
                current = absolute
            } else if current <= absolute {
                current = min(new, absolute)
                previous = gesture
            }
              
        } else if current < 0 {
            
            if current < -absolute {
                current = -absolute
            } else if current >= -absolute {
                current = max(new, -absolute)
                previous = gesture
            }
            
        }
        
//
//        horizontal.update(
//            new: (horizontal.current + (gesture.translation.width - horizontal.previous) / scale),
//            absolute: horizontal_absolute
//        )
//
//        vertical.current = (vertical.current + (gesture.translation.height - vertical.previous) / scale)
//
//        horizontal.previous = gesture.translation.width
        
    }
    
}

struct MapView: View {

    @FetchRequest var results: FetchedResults<CourseImage>
    
    @State var fallback: Data?
    
    @State var scale: CGFloat = 1.0
    @State var vertical = DragAxis(previous: 0, current: 0)
    @State var horizontal = DragAxis(previous: 0, current: 0)
    
    private let map_edges_ignore: Edge.Set
    
    init(uuid: UUID) {
        
        _results = FetchRequest<CourseImage>(
            sortDescriptors: [],
            predicate: NSPredicate(format: "uuid = %@", uuid as CVarArg),
            animation: .default
        )
        
        if #available(watchOS 10, *) {
            self.map_edges_ignore = .vertical
        } else {
            self.map_edges_ignore = .bottom
        }
        
        if uuid == UUID(uuidString: "00000000-0000-0000-0000-000000000000") {
            fallback = try? Data(contentsOf: Bundle.main.url(forResource: "map", withExtension: "png")!)
        }

    }
    
    var body: some View {
        
        if let image = results.first?.data ?? fallback {
            
            GeometryReader(content: { geometry in
                
                let square = max(geometry.frame(in: .global).size.width, geometry.frame(in: .global).size.height)
                let absolute: CGFloat = floor(((square * scale) - geometry.frame(in: .global).size.height) / 2 / scale)
                
                Image(uiImage: UIImage(data: image)!)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: square, height: square, alignment: .center)
                    .offset(CGSize(width: horizontal.constrain(absolute: absolute), height: vertical.constrain(absolute: absolute)))
                    .padding(.leading, -(square - geometry.frame(in: .global).size.width) / 2)
                    .scaleEffect(scale)
                    .focusable(true)
                    .digitalCrownRotation($scale, from: 1.0, through: 4, by: 0.1, sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true)
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            
                            horizontal.update(gesture: gesture.translation.width, scale: scale, absolute: absolute)
                            vertical.update(gesture: gesture.translation.height, scale: scale, absolute: absolute)
                            
//                            horizontal.update(
//                                new: (horizontal.current + (gesture.translation.width - horizontal.previous) / scale),
//                                absolute: horizontal_absolute
//                            )
//
//                            vertical.current = (vertical.current + (gesture.translation.height - vertical.previous) / scale)
//
//                            horizontal.previous = gesture.translation.width
//                            vertical.previous = gesture.translation.height
                            
                        }
                        .onEnded { value in
                            horizontal.previous = 0
                            vertical.previous = 0
                        })
                
            })
                .edgesIgnoringSafeArea(self.map_edges_ignore)
            
        }
        
    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(uuid: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!)
    }
}
