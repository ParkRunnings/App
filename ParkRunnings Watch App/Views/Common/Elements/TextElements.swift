//
//  TextElements.swift
//  ParkRunnings WatchKit Extension
//
//  Created by Charlie on 1/5/2022.
//

import SwiftUI

struct TitleTextElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let text: String
    
    var body: some View {
        
        Text(text)
            .font(Font.system(size: design.size(text: .title), weight: .heavy, design: .default))
            .foregroundColor(Colour(hex: "#FFFFFF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .lineLimit(2)
        
    }
    
}

struct SubtitleTextElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let text: String
    
    var body: some View {
        
        Text(.init(text))
            .font(Font.system(size: design.size(text: .subtitle), weight: .bold, design: .default))
            .italic()
            .foregroundColor(Colour(hex: "#7D7D7D"))
            .tint(Colour(hex: "#0785CF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct HeadingTextElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let text: String
    
    var body: some View {
        
        Text(text)
            .font(Font.system(size: design.size(text: .heading), weight: .bold, design: .default))
            .foregroundColor(Colour(hex: "#FFFFFF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct SubheadingTextElement: View {
    
    @EnvironmentObject var design: DesignController
    
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
            .font(Font.system(size: design.size(text: .subheading), weight: .medium, design: .default))
            .italic()
            .foregroundColor(Colour(hex: colour))
            .tint(Colour(hex: "#0785CF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct InputHelpTextElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let text: String
    let colour: String
    
    init(text: String) {
        self.text = text
        self.colour = "#2B6FA6"
    }
    
    var body: some View {
        
        Text(.init(text))
            .font(Font.system(size: design.size(text: .input_help), weight: .medium, design: .default))
            .italic()
            .foregroundColor(Colour(hex: colour))
            .tint(Colour(hex: "#0785CF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct InputAthleteTextElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let text: String
    let colour: String
    
    init(text: String) {
        self.text = text
        self.colour = "#FFFFFF"
    }
    
    var body: some View {
        
        Text(.init(text))
            .font(Font.system(size: design.size(text: .input_athlete), weight: .heavy, design: .monospaced))
            .foregroundColor(Colour(hex: colour))
            .lineLimit(nil)
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct AthleteNameTextElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let text: String
    
    var body: some View {
        
        Text(text)
            .font(Font.system(size: design.size(text: .athlete_name), weight: .heavy, design: .default))
            .foregroundColor(Colour(hex: "#FFFFFF"))
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct AthleteNumberTextElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let text: String
    let colour: String
    
    init(text: String, colour: String = "#FFFFFF") {
        self.text = text
        self.colour = colour
    }
    
    var body: some View {
        
        Text(.init(text))
            .font(Font.system(size: design.size(text: .athlete_number), weight: .heavy, design: .monospaced))
            .foregroundColor(Colour(hex: colour))
            .lineLimit(nil)
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        
    }
    
}

struct ProgressTextElement: View {
    
    @EnvironmentObject var design: DesignController
    
    let text: String
    let colour: String
    
    init(text: String, colour: String = "#FFFFFF") {
        self.text = text
        self.colour = colour
    }
    
    var body: some View {
        
        Text(text)
            .italic()
            .monospacedDigit()
            .font(Font.system(size: design.size(text: .progress_detail), weight: .bold))
            .foregroundColor(Colour(hex: colour))
            .lineLimit(1)
            .listRowPlatterColor(.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .shadow(color: Colour.black, radius: 4, x: 0, y: 0)
        
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
        
        ProgressTextElement(text: "SAT 04")

//        TitleTextElement(text: "ParkRun")
//
//        SubtitleTextElement(text: "Welcome [parkrun.com](https://parkrun.com)")
//
//        HeadingTextElement(text: "1. Barcode Setup")
//
//        SubheadingTextElement(text: "This is some subheading content")
//
//        InputAthleteTextElement(text: "A123456")
//
//        AthleteNumberTextElement(text: "A123456")
//
//        TitleElement(title: "Testing", subtitle: "Poopy butthole")
        
    }
}
