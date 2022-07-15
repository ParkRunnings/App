//
//  Button.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 15/5/2022.
//

import SwiftUI

struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

extension View {
    func delayTouches() -> some View {
        Button(action: {}) {
            highPriorityGesture(TapGesture())
        }
        .buttonStyle(NoButtonStyle())
    }
}

struct ButtonElement<A: View>: View {
    
    let colour: Colour
    let radius: Double
    let haptic: WKHapticType = .click
    
    @ViewBuilder var content: A
    
    var body: some View {
    
        Button(action: {}, label: {
            content
                .background(
                    RoundedRectangle(cornerRadius: radius)
                        .fill(colour)
                        .shadow(radius: 3)
                )
        })
        .simultaneousGesture(TapGesture().onEnded({
            WKInterfaceDevice.current().play(haptic)
        }))
        .buttonStyle(PlainButtonStyle())
        .listRowPlatterColor(.clear)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
      
    }
    
}


struct ButtonNavigation<A: View, B: View>: View {
    
    @Binding var active: Bool
    
    @ViewBuilder var button: A
    @ViewBuilder var destination: B
    
    var body: some View {

        ZStack(alignment: .leading, content: {
            
            NavigationLink(destination: destination, isActive: $active, label: { EmptyView() })
                .hidden()
                .buttonStyle(PlainButtonStyle())
                
            button
            
        })
        .listRowPlatterColor(.clear)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .onAppear(perform: {
            active = false
        })
        
    }
    
}


