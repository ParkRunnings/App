//
//  InputConfirmationElement.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 8/5/2022.
//

import SwiftUI

struct InputConfirmationElement: View {
    
    @EnvironmentObject var meta: MetaController
    @EnvironmentObject var design: DesignController
    
    @Environment(\.presentationMode) var presentation
    
    @Binding var runner: Runner?
    @Binding var nav_confirmation: Bool
    
    var body: some View {
        
        if let runner = runner {
            
            ZStack(alignment: .bottom, content: {
                
                List(content: {
                    
                    VStack(alignment: .leading, spacing: 2, content: {
                       
                        AthleteNameTextElement(text: runner.display_name)
                            .padding(.trailing, 6)
                        
                        AthleteNumberTextElement(text: runner.a_number)
                            .opacity(0.5)
                        
                    })
                    .listRowPlatterColor(.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    if let error = runner.error {
                        SubtitleTextElement(text: error + "\n\nWe were not able to find this runner. Add anyway?")
                            .padding(.bottom, 10)
                    } else {
                        VStack(alignment: .leading, spacing: 3, content: {
                            
                            ProfileStat(stat: "Runs", value: runner.display_runs)
                            ProfileStat(stat: "Fastest", value: runner.display_fastest)
                            
                        })
                        .padding(.trailing, 10)
                        .listRowPlatterColor(.clear)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    BarcodeCardElement(number: runner.a_number)
                    
                    ListOverscroll(height: design.size(size: .confirmation_over_scroll))
                    
                })
                .listStyle(.plain)
                
                ListBottomBlur()
                    .ignoresSafeArea(.all, edges: .bottom)
                    .frame(height: design.size(size: .confirmation_blur_height), alignment: .bottom)
                    .padding(.bottom, design.size(size: .button_bottom_margin))
                
                HStack(alignment: .top, spacing: 4, content: {

                    CardHalf(symbol: "trash.circle.fill", colour: Colour(hex: "#CE4F30"))
                        .simultaneousGesture(TapGesture().onEnded({ nav_confirmation = false }))

                    CardHalf(symbol: "person.crop.circle.fill.badge.plus", colour: Colour(hex: "#5BD96F"))
                        .simultaneousGesture(TapGesture().onEnded({
                            meta.update_runner(runner: runner)
                            presentation.wrappedValue.dismiss()
                        }))

                })
                
            })
            .padding(.bottom, -design.size(size: .button_bottom_margin))
            
            
            
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
        
    }
    
}

struct InputConfirmationElement_Previews: PreviewProvider {
    static var previews: some View {
        
        InputConfirmationElement(
            runner: .constant(Runner(context: DataController.shared.container.viewContext, number: "12345", name: "Charles Schacher", runs: "12", fastest: "23:55", error: nil, created: Date.now, refreshed: Date.now, results: [])),
            nav_confirmation: .constant(true)
        )
        
        InputConfirmationElement(
            runner: .constant(nil),
            nav_confirmation: .constant(true)
        )
        
    }
}
