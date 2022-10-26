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
                    
                    VStack(alignment: .leading, spacing: 6, content: {
                        
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
                    }
                    
//                    if let fastest = runner.results_fastest.first {
//                        StatValueElement(colour: "#45BB70", symbol: design.watch.version >= 9.0 ? "trophy.fill" : "timer", header: "Fastest", detail: fastest.display_date, value: fastest.display_time)
//                            .padding(.bottom, 4)
//                    }
//
//                    if let latest = runner.results_sorted.last {
//                        StatValueElement(colour: "#7145BA", symbol: design.watch.version >= 9.0 ? "figure.run" : "figure.walk", header: "Runs", detail: latest.display_date, value: String(latest.number))
//                            .padding(.bottom, 4)
//                    }
                    
                    BarcodeCardElement(number: runner.a_number)
                    
                    ListOverscroll(height: design.size(size: .confirmation_over_scroll))
                    
                })
                .listStyle(.plain)
                
                ListBottomBlur()
                    .ignoresSafeArea(.all, edges: .all)
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
    
    static let design = DesignController()
  
    static var previews: some View {
        
        InputConfirmationElement(
            runner: .constant(Runner(context: DataController.shared.container.viewContext, number: "12345", name: "Charles Schacher", error: nil, created: Date.now, refreshed: Date.now)),
            nav_confirmation: .constant(true)
        )
        .environmentObject(design)
        
        InputConfirmationElement(
            runner: .constant(nil),
            nav_confirmation: .constant(true)
        )
        .environmentObject(design)
        
    }
}
