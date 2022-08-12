//
//  WelcomeView.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 1/5/2022.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var design: DesignController
    
    @State private var nav_continue: Bool = false
    
    var body: some View {
        
        NavigationView(content: {
            
            VStack(alignment: .leading, content: {
                
                List(content: {
                    
                    TitleElement(
                        title: "Welcome",
                        subtitle: [
                            "Park Runnings is an unoffical Apple Watch companion for ParkRun - an organised weekly 5km run",
                            "To use this app you need to already have a ParkRun account and barcode.",
                            "If you don’t, you can sign up for free at [parkrun.com](https://parkrun.com)"
                        ].joined(separator: "\n\n")
                    )
                        .padding(.bottom, 10)
                    
                })
                    .padding(.bottom, -design.size(size: .button_bottom_margin))
                
                ButtonNavigation(active: $nav_continue, button: {
                    CardShort(title: "Continue", symbol: "arrow.forward.circle", colour: Colour(hex: "#31D78B"))
                }, destination: {
                    SetupView()
                })
                    .simultaneousGesture(
                        TapGesture().onEnded({
                            print("Tap gesture")
                            nav_continue = true
                        })
                    )
                    .background(content: {
                        ListBottomBlur()
                            .padding(.bottom, -10)
                            .padding(.top, -design.size(size: .button_bottom_margin))
                    })
                    .padding(.bottom, -design.size(size: .button_bottom_margin))
            })
            
        })
        .onAppear(perform: {
            nav_continue = false
        })
    }
    
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(MetaController())
    }
        
}
