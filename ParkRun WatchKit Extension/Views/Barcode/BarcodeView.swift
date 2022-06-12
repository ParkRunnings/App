//
//  Barcode.swift
//  ParkRun
//
//  Created by Charlie on 7/4/2022.
//

import SwiftUI

struct BarcodeView: View {
  
    @EnvironmentObject var runner: RunnerController
    
    var body: some View {
        
        BarcodeCardElement(number: runner.a_number)
        
    }
    
}

struct BarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeView()
    }
}
