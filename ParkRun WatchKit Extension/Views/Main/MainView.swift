//
//  MainView.swift
//  ParkRun WatchKit Extension
//
//  Created by Charlie on 2/4/2022.
//

import SwiftUI
import BarcodeKit
import CoreLocation

struct MainView: View {
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var location: LocationController
    @EnvironmentObject var meta: MetaController
    
    @FetchRequest(sortDescriptors: []) var runners: FetchedResults<Runner>
    @FetchRequest(sortDescriptors: []) var events: FetchedResults<Event>
    
//    @State var cards: Array<MainCardType> = MainCardType.allCases.sorted(by: { $0.rawValue < $1.rawValue })
    
    var body: some View {
        
        List(content: {
            
            MainTitleElement()
            
            Text("\(events.count)")
            
//            ForEach(0 ..< cards.count, id: \.self, content: { index in
//
//                let type = cards[index]
//
//                if !(type == .barcode && runners.count == 0) {
//
//                    NavigationLink(destination: {
//
//                        self.destination(type: type)
//                            .environment(\.managedObjectContext, context)
//
//                    }, label: {
//                        MainCardElement(type: type)
//                    })
//                    .listRowPlatterColor(.clear)
//                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
//
//                }
//
//            })
            
        })
        .listStyle(.carousel)
        .sheet(isPresented: !$meta.setup, content: {
            WelcomeView()
                .toolbar(content: {
                    ToolbarItem(id: "x", placement: .cancellationAction, showsByDefault: false, content: {
                        Text("")
                    })
                })
//                .navigationBarBackButtonHidden(true)
//                .navigationBarHidden(true)
        })
        .onLoad(perform: {
            location.start()
        })
        
    }
    
//    @ViewBuilder
//    func destination(type: MainCardType) -> some View {
//
//        switch type {
//
//        case .barcode:
//             BarcodeView()
//
//        case.setup:
//            InputView()
//
//        }
//
//    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
