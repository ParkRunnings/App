//
//  EventLocationElement.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 2/5/2022.
//

import SwiftUI

struct EventLocationElement: View {

    var name: String
    var country: String
    var distance: String
    
    init(name: String, country: String, meters: Int) {
        
        self.name = name
        self.country = country
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.decimalSeparator = ","
        
        switch meters {
            
            case 0..<100:
            self.distance = "Here"
            
            case 100..<1000:
            self.distance = "\(formatter.string(for: floor(Double(meters)/100.0) * 100.0) ?? "?")m"
            
            case 1000..<Int.max:
            self.distance = "\(formatter.string(for: floor(Double(meters)/1000.0)) ?? "?")km"
            
            default:
            self.distance = ""
            
        }
        
    }
    
    var body: some View {
        
        ButtonElement(colour: Colour.clear, radius: 0, content: {
            
            VStack(alignment: .leading, spacing: 4, content: {
                
                HeadingTextElement(text: name)
                    .padding(.trailing, 10)
                
                HStack(alignment: .bottom, spacing: 0, content: {
                    
                    SubheadingTextElement(text: country)
                    
                    Spacer()
                    
                    SubheadingTextElement(text: distance, colour: "#51C48E")
                    
                })
                
                
            })
            
        })
        
    }
    
}

struct EachEventElement_Previews: PreviewProvider {

    static var previews: some View {
        EventLocationElement(name: "Cooks River", country: "Australia", meters: 9)
        EventLocationElement(name: "Cooks River", country: "Australia", meters: 919)
        EventLocationElement(name: "Frankston Nature Conservation Reserve", country: "Australia", meters: 91999999)
    }

}
