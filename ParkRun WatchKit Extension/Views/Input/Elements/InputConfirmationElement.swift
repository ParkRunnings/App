//
//  InputConfirmationElement.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 8/5/2022.
//

import SwiftUI

struct InputConfirmationElement: View {
    
    @Environment(\.presentationMode) var presentation
    
    var number: String
    @Binding var runner: Runner?
    @Binding var error: String?
    
    var body: some View {
        
        if runner == nil && error == nil {
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        
        } else {
            
            VStack(alignment: .leading, spacing: 0, content: {
                
                List(content: {
                    
                    VStack(alignment: .leading, spacing: 2, content: {
                       
                        HalfTitleTextElement(text: runner?.name ?? "Unknown Runner")
                            .padding(.trailing, 6)
                        
                        MiniAthleteTextElement(text: "A\(number)")
                            .opacity(0.5)
                        
                    })
                    .listRowPlatterColor(.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    if let error = error {
                        
                        SubtitleTextElement(text: error + ", add runner anyway?")
                        
                    }
                    
                    if let runner = runner {
                        
                        VStack(alignment: .leading, spacing: 3, content: {
                            
                            ProfileStat(stat: "Runs", value: runner.runs ?? "-")
                            
                            ProfileStat(stat: "Fastest", value: runner.fastest ?? "-")
                            
                        })
                        .padding(.trailing, 10)
                        .listRowPlatterColor(.clear)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                    }
                    
                    ListOverscroll()
                    
                })
                .padding(.bottom, -10)
                
                
                HStack(alignment: .top, spacing: 4, content: {
                    
                    CardHalf(symbol: "trash.circle.fill", colour: Colour(hex: "#CE4F30"))
                    CardHalf(symbol: "person.crop.circle.fill.badge.plus", colour: Colour(hex: "#45BA70"))
                    
                })
                .padding(.bottom, -20)
                
            })
            
            
            
        }
        
    }
    
}

struct InputConfirmationElement_Previews: PreviewProvider {
    static var previews: some View {
        
        InputConfirmationElement(
            number: "12345",
            runner: .constant(Runner(context: DataController.shared.container.viewContext, number: "12345", name: "Charles Schacher", fastest: "23:55", runs: "12")),
            error: .constant(nil)
        )
        
        InputConfirmationElement(
            number: "ABC123",
            runner: .constant(nil),
            error: .constant("Network error")
        )
        
    }
}
