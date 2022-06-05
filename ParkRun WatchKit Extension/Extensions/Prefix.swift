//
//  Prefix.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 30/4/2022.
//

import SwiftUI

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
