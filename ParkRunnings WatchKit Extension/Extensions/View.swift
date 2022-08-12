//
//  View.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 11/4/2022.
//

import Foundation
import SwiftUI

struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }

}

struct OnTouchUpDown: ViewModifier {
    
    @State private var pressed = false
    
    let down: () -> Void
    let up: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !self.pressed {
                        self.pressed = true
                        self.down()
                    }
                }
                .onEnded { _ in
                    self.pressed = false
                    self.up()
                })
    }
    
}

extension View {

    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
    func onTouchUpDown(down: @escaping () -> Void, up: @escaping () -> Void) -> some View {
        modifier(OnTouchUpDown(down: down, up: up))
    }
    
    func hidden(_ hide: Bool) -> some View {
        opacity(hide ? 0 : 1)
    }

}
