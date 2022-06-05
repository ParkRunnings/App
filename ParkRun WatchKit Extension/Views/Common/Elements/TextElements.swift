//
//  TextElements.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 1/5/2022.
//

import SwiftUI

struct TitleTextElement: View {
    
    let text: String
    
    var body: some View {
        
        Text(text)
            .font(Font.system(size: 28, weight: .heavy, design: .default))
            .foregroundColor(Colour(hex: "#FFFFFF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct HalfTitleTextElement: View {
    
    let text: String
    
    var body: some View {
        
        Text(text)
            .font(Font.system(size: 22, weight: .heavy, design: .default))
            .foregroundColor(Colour(hex: "#FFFFFF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct SubtitleTextElement: View {
    
    let text: String
    
    var body: some View {
        
        Text(.init(text))
            .font(Font.system(size: 15, weight: .bold, design: .default))
            .italic()
            .foregroundColor(Colour(hex: "#7D7D7D"))
            .tint(Colour(hex: "#0785CF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct HeadingTextElement: View {
    
    let text: String
    
    var body: some View {
        
        Text(text)
            .font(Font.system(size: 17, weight: .bold, design: .default))
            .foregroundColor(Colour(hex: "#FFFFFF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct SubheadingTextElement: View {
    
    let text: String
    let colour: String
    
    init(text: String) {
        self.text = text
        self.colour = "#7D7D7D"
    }
    
    init(text: String, colour: String) {
        self.text = text
        self.colour = colour
    }
    
    var body: some View {
        
        Text(.init(text))
            .font(Font.system(size: 15, weight: .medium, design: .default))
            .italic()
            .foregroundColor(Colour(hex: colour))
            .tint(Colour(hex: "#0785CF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct HelpTextElement: View {
    
    let text: String
    let colour: String
    
    init(text: String) {
        self.text = text
        self.colour = "#2B6FA6"
    }
    
    var body: some View {
        
        Text(.init(text))
            .font(Font.system(size: 13, weight: .medium, design: .default))
            .italic()
            .foregroundColor(Colour(hex: colour))
            .tint(Colour(hex: "#0785CF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct AthleteTextElement: View {
    
    let text: String
    let colour: String
    
    init(text: String) {
        self.text = text
        self.colour = "#FFFFFF"
    }
    
    var body: some View {
        
        Text(.init(text))
            .font(Font.system(size: 18, weight: .heavy, design: .monospaced))
            .foregroundColor(Colour(hex: colour))
            .lineLimit(nil)
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct MiniAthleteTextElement: View {
    
    let text: String
    let colour: String
    
    init(text: String) {
        self.text = text
        self.colour = "#FFFFFF"
    }
    
    var body: some View {
        
        Text(.init(text))
            .font(Font.system(size: 12, weight: .heavy, design: .monospaced))
            .foregroundColor(Colour(hex: colour))
            .lineLimit(nil)
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}


struct TitleElement: View {
    
    let title: String
    let subtitle: String?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2, content: {
            TitleTextElement(text: title)
            
            if let subtitle = subtitle {
                SubtitleTextElement(text: subtitle)
            }
            
        })
        .listRowPlatterColor(.clear)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .padding(.bottom, 20)
        
    }
    
}

struct TextElements_Previews: PreviewProvider {
    static var previews: some View {
        
        TitleTextElement(text: "ParkRun")
        
        SubtitleTextElement(text: "Welcome [parkrun.com](https://parkrun.com)")
        
        HeadingTextElement(text: "1. Barcode Setup")
        
        SubheadingTextElement(text: "This is some subheading content")
        
        AthleteTextElement(text: "A123456")
        
        MiniAthleteTextElement(text: "A123456")
        
        TitleElement(title: "Testing", subtitle: "Poopy butthole")
        
    }
}
