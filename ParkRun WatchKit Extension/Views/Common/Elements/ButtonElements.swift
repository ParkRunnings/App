//
//  Button.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 15/5/2022.
//

import SwiftUI

struct ButtonElement<A: View>: View {
    
    let colour: Colour
    let radius: Double
    let haptic: WKHapticType = .click
    
    var min_scale: Double? = nil
    var min_alpha: CGFloat? = nil
    let duration: Double = 0.07
    
    @ViewBuilder var content: A
    
    @State private var alpha: Double = 1.0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
    
        content
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(colour)
                    .shadow(radius: 3)
            )
            .opacity(alpha)
            .scaleEffect(scale)
            .onTouchUpDown(down: {
                withAnimation(.easeIn(duration: duration), {
                    scale = min_scale ?? 0.92
                    alpha = min_alpha ?? 0.6
                })
            }, up: {
                WKInterfaceDevice.current().play(haptic)
                withAnimation(.easeIn(duration: duration), {
                    scale = 1.0
                    alpha = 1.0
                })
            })
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


