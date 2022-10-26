//
//  Barcode.swift
//  ParkRun
//
//  Created by Charlie on 7/4/2022.
//

import SwiftUI
import WatchKit

struct BarcodeView: View {
  
    @EnvironmentObject var design: DesignController
    @EnvironmentObject var runner: RunnerController
    
    var body: some View {
        
        VStack(content: {
            BarcodeCardElement(number: runner.a_number, ratio: design.size(size: .barcode_rotated_ratio))
                .rotationEffect(Angle(degrees: design.wrist == .right ? 90 : -90 ))
        }).onAppear(perform: {
            WKExtension.shared().isAutorotating = true
        }).onDisappear(perform: {
            WKExtension.shared().isAutorotating = false
        })
        .padding(.top, design.watch.status_height / 2)
    }
    
}

struct BarcodeView_Previews: PreviewProvider {
    
    static let design = DesignController()
    static let runner = RunnerController()
    
    static var previews: some View {
        BarcodeView()
            .environmentObject(design)
            .environmentObject(runner)
    }
}
