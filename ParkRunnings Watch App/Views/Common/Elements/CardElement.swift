//
//  CardElement.swift
//  ParkRun
//
//  Created by Charlie on 4/4/2022.
//

import SwiftUI


struct CardIcon: View {
    
    @EnvironmentObject var design: DesignController
    
    let symbol: String
    let foreground_colour: Colour
    
    init(symbol: String, foreground_colour: Colour? = nil) {
        self.symbol = symbol
        self.foreground_colour = foreground_colour ?? Colour(hex: "#FFFFFF")
    }
    
    var body: some View {
   
        Image(systemName: symbol)
            .font(Font.system(
                size: design.size(text: .card_icon),
                weight: .bold,
                design: .default
            ))
            .foregroundColor(foreground_colour)
            .frame(width: design.size(text: .card_icon), height: design.size(text: .card_icon))
        
    }
    
}

struct CardContent: View {
    
    let title: String
    let symbol: String
    private let foreground_colour: Colour?
    
    init(title: String, symbol: String, foreground_colour: Colour? = nil) {
        self.title = title
        self.symbol = symbol
        self.foreground_colour = foreground_colour
    }
    
    var body: some View {
        
        HStack(content: {
            
            HeadingTextElement(text: title, foreground_colour: foreground_colour)
            
            Spacer()
            
            CardIcon(symbol: symbol, foreground_colour: foreground_colour)
            
        })
        
    }

    
}

struct CardShort: View {
    
    @EnvironmentObject var design: DesignController
    
    let title: String
    let symbol: String
    let colour: Colour
    
    var body: some View {
        
        ButtonElement(colour: colour, radius: design.size(size: .card_short_radius), content: {
            CardContent(title: title, symbol: symbol)
            .padding(.horizontal, design.size(size: .card_short_horizontal))
            .padding(.vertical, design.size(size: .card_short_vertical))
        })
        
    }
    
}

struct CardMedium: View {
    
    @EnvironmentObject var design: DesignController
    
    let title: String
    let symbol: String
    let colour: Colour
    
    var body: some View {
        
        ButtonElement(colour: colour, radius: design.size(size: .card_medium_radius), content: {
            CardContent(title: title, symbol: symbol)
            .frame(height: design.size(size: .card_medium_height), alignment: .bottom)
            .padding(.all, design.size(size: .card_medium_padding))
        })
        
    }
    
}

struct CardTall: View {
    
    @EnvironmentObject var design: DesignController
    
    let title: String
    let symbol: String
    let colour: Colour
    private let foreground_colour: Colour?
    
    init(title: String, symbol: String, colour: Colour, foreground_colour: Colour? = nil) {
        self.title = title
        self.symbol = symbol
        self.colour = colour
        self.foreground_colour = foreground_colour
    }
    
    var body: some View {
        
        ButtonElement(colour: colour, radius: design.size(size: .card_tall_radius), content: {
            CardContent(title: title, symbol: symbol, foreground_colour: foreground_colour)
            .frame(height: design.size(size: .card_tall_height), alignment: .bottom)
            .padding(.all, design.size(size: .card_tall_padding))
        })
        
    }
    
}

struct CardHalf: View {
    
    @EnvironmentObject var design: DesignController
    
    let symbol: String
    let colour: Colour
    
    var body: some View {
        
        ButtonElement(colour: colour, radius: design.size(size: .card_half_radius), content: {
            CardIcon(symbol: symbol)
                .padding(.all, design.size(size: .card_half_padding))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: design.size(size: .card_half_height), alignment: .center)
        })
        
    }
    
}

struct CardMicro: View {
    
    let symbol: String
    
    var body: some View {
        
        ButtonElement(colour: Colour.clear, radius: 0, content: {
            CardIcon(symbol: symbol)
                .opacity(0.5)
        })
        
    }
    
}

//struct CardButton: ButtonStyle {
//
//    func makeBody(configuration: Configuration) -> some View {
//
//        configuration.label
//            .scaleEffect(configuration.isPressed ? 0.92 : 1)
//            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
//
//    }
//
//}

struct CardElement_Previews: PreviewProvider {
    
    static let design = DesignController()
    
    static var previews: some View {
        
        CardShort(title: "Continue", symbol: "arrow.forward.circle", colour: Colour(hex: "#31D78B"))
            .environmentObject(design)
        
        CardTall(title: "Location Setup", symbol: "location.circle.fill", colour: Colour(hex: "#531459"))
            .environmentObject(design)
        
        HStack(alignment: .top, spacing: 4, content: {
            
            CardHalf(symbol: "hand.thumbsdown.fill", colour: Colour(hex: "#D1852B"))
                .environmentObject(design)
            
            CardHalf(symbol: "hand.thumbsup.fill", colour: Colour(hex: "#4CEB67"))
                .environmentObject(design)
            
        })
        
    }
}
