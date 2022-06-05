//
//  HelpView.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 5/5/2022.
//

import SwiftUI

struct HelpView: View {
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 24, content: {
            
            List(content: {
                
                TitleTextElement(text: "Help")
                    .padding(.bottom, -16)
                
                SubheadingTextElement(text: "To add a barcode to this app, you need to enter your ParkRun athlete number.")
                    
                Image("DummyBarcode")
                    .resizable()
                    .scaledToFit()
                    .listRowPlatterColor(.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                SubheadingTextElement(text: "You can find your number underneath your current paper barcode.")
                
            })
            .listStyle(.plain)
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
        })
        
    }
    
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
