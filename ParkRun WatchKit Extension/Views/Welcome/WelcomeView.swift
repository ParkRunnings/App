//
//  WelcomeView.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 1/5/2022.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var nav_continue: Bool = false
    
    var body: some View {
        
        NavigationView(content: {
            
            VStack(alignment: .leading, content: {
                
//                NavigationLink(destination: SetupView(), isActive: $nav_continue, label: {})
//                    .buttonStyle(PlainButtonStyle())
                
                List(content: {
                    
                    TitleElement(
                        title: "Welcome",
                        subtitle: "ParkRun is an organised weekly 5km run, held in parks all around the world.\n\nTo use this app you need to already have a ParkRun account and barcode.\n\nIf you don’t, you can sign up for free at [parkrun.com](https://parkrun.com)."
                    )
                        .padding(.bottom, 10)
                    
                })
                    .padding(.bottom, -20)
                
                ButtonNavigation(active: $nav_continue, button: {
                    CardShort(title: "Continue", symbol: "arrow.forward.circle", colour: Colour(hex: "#31D78B"), min_alpha: 1.0)
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
                            .padding(.top, -20)
                    })
                    .padding(.bottom, -20)
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
