//
//  CardElement.swift
//  ParkRun
//
//  Created by Charlie on 4/4/2022.
//

import SwiftUI


struct CardIcon: View {
    
    let symbol: String
    
    var body: some View {
   
        Image(systemName: symbol)
            .font(Font.system(
                size: 20,
                weight: .bold,
                design: .default
            ))
            .foregroundColor(Colour(hex: "#FFFFFF"))
            .frame(width: 20, height: 20)
        
    }
    
}

struct CardContent: View {
    
    let title: String
    let symbol: String
    
    var body: some View {
        
        HStack(content: {
            
            HeadingTextElement(text: title)
            
            Spacer()
            
            CardIcon(symbol: symbol)
            
        })
        
    }

    
}

struct CardShort: View {
    
    let title: String
    let symbol: String
    let colour: Colour
    
    var min_alpha: CGFloat? = nil
    
    var body: some View {
        
        ButtonElement(colour: colour, radius: 20, min_alpha: min_alpha, content: {
            CardContent(title: title, symbol: symbol)
            .padding(.horizontal, 14.0)
            .padding(.vertical, 12.0)
        })
        
    }
    
}

struct CardMedium: View {
    
    let title: String
    let symbol: String
    let colour: Colour
    
    var body: some View {
        
        ButtonElement(colour: colour, radius: 24, content: {
            CardContent(title: title, symbol: symbol)
            .frame(height: 50, alignment: .bottom)
            .padding(.all, 14.0)
        })
        
    }
    
}

struct CardTall: View {
    
    let title: String
    let symbol: String
    let colour: Colour
    
    var body: some View {
        
        ButtonElement(colour: colour, radius: 24, content: {
            CardContent(title: title, symbol: symbol)
            .frame(height: 72, alignment: .bottom)
            .padding(.all, 14.0)
        })
        
    }
    
}

struct CardHalf: View {
    
    let symbol: String
    let colour: Colour
    
    var body: some View {
        
        CardIcon(symbol: symbol)
            .padding(.all, 14.0)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(colour)
                    .shadow(radius: 3)
            )
        
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
    static var previews: some View {
        
        CardShort(title: "Continue", symbol: "arrow.forward.circle", colour: Colour(hex: "#31D78B"))
        
//        CardMedium(title: "Barcode Setup", symbol: "barcode", colour: Colour(hex: "#D1852B"))
        
        CardTall(title: "Location Setup", symbol: "location.circle.fill", colour: Colour(hex: "#531459"))
        
        HStack(alignment: .top, spacing: 4, content: {
            
            CardHalf(symbol: "hand.thumbsdown.fill", colour: Colour(hex: "#D1852B"))
            
            CardHalf(symbol: "hand.thumbsup.fill", colour: Colour(hex: "#4CEB67"))
            
        })
        
//        let cards = CardType.all()
//
//        ForEach(0 ..< cards.count, id: \.self, content: { index in
//            let type = cards[index]
//            CardElement(type: type)
//        })
        
    }
}
