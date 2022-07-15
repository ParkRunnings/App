//
//  Barcode.swift
//  ParkRun
//
//  Created by Charlie on 7/4/2022.
//

import SwiftUI
import WatchKit

struct BarcodeView: View {
  
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    @EnvironmentObject var runner: RunnerController
    
    var body: some View {
        
        VStack(content: {
            BarcodeCardElement(number: runner.a_number)
                .rotationEffect(Angle(degrees: 90))
        }).onAppear(perform: {
            WKExtension.shared().isAutorotating = true
        }).onDisappear(perform: {
            WKExtension.shared().isAutorotating = false
        })
        .padding(.top, 30)
    }
    
}

struct BarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeView()
    }
}
