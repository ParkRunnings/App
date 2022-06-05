//
//  Barcode.swift
//  ParkRun
//
//  Created by Charlie on 7/4/2022.
//

import SwiftUI

struct BarcodeView: View {
  
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: []) var runners: FetchedResults<Runner>
    
    var body: some View {
        
        List(content: {
            
            ForEach(runners, content: { runner in
                BarcodeCardElement(number: runner.number)
            })
            
        })
        .listStyle(.elliptical)
        
    }
    
}

struct BarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeView()
    }
}
