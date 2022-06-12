//
//  InputView.swift
//  ParkRun
//
//  Created by Charlie on 7/4/2022.
//

import SwiftUI

struct InputView: View {

    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var meta: MetaController
    
    @State private var number: String = ""
    @State private var buttons: Array<Array<InputButtonType>> = Array(
        (Array(1...9) + [10, 0, 11])
    ).map({
        InputButtonType(rawValue: $0)!
    }).chunked(into: 3)
    
    @State private var runner: Runner?
    @State private var polling_for: String?
    @State private var nav_confirmation: Bool = false
    @State private var nav_help: Bool = false

    var body: some View {

        VStack(alignment: .center, spacing: 0, content: {
        
            HStack(alignment: .center, spacing: 0, content: {
                
                AthleteTextElement(text: "A")
                AthleteTextElement(text: "\($number.wrappedValue)")
                
            })
                .padding(.bottom, 6)

            ForEach(0 ..< buttons.count, id: \.self, content: { row in
            
                HStack(alignment: .center, spacing: 0, content: {
                
                    ForEach(0 ..< buttons[row].count, id: \.self, content: { column in
                        
                        let type = buttons[row][column]
                        
                        InputButtonElement(type: type)
                            .simultaneousGesture(TapGesture().onEnded({
                                
                                switch (type, number.count) {
                
                                case (.confirm, 1 ... .max):
                                    
                                    polling_for = number
                                    nav_confirmation = true
                                    
                                    Task(operation: {
                                        
                                        do {
                                            let runner_ = try await RunnerController.shared.scrape(number: number)
                                            
                                            if runner_.number == polling_for {
                                                runner = runner_
                                                polling_for = nil
                                            }
                                            
                                        } catch RunnerControllerError.scrape(let title) {
                                            
                                            runner = Runner.init(context: context, number: number, error: title)
                                            polling_for = nil
                                        
                                        }
                                        
                                    })
                                    
                                case (.delete, 1 ... .max):
                                    number.removeLast()
                
                                case (.delete, 0), (.confirm, 0):
                                    break
                
                                default:
                                    number.append(contentsOf: String(type.rawValue))
                
                                }
                                
                            }))
                        
                    })
                
                })
            
            })
            
            ButtonNavigation(active: $nav_help, button: { HelpTextElement(text: "Help") }, destination: { HelpView() })
                .padding(.top, 6)
            
        })
            .sheet(isPresented: $nav_confirmation, onDismiss: {
                if meta.setup_barcode { presentation.wrappedValue.dismiss() }
            }, content: {
                InputConfirmationElement(runner: $runner, nav_confirmation: $nav_confirmation)
                    .toolbar(content: {
                        ToolbarItem(id: "x", placement: .cancellationAction, showsByDefault: false, content: {
                            Text("")
                        })
                    })
            })
            .padding(.bottom, 2)
            .padding(.horizontal, 2)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform: {
                runner = nil
                polling_for = nil
                nav_confirmation = false
                nav_help = false
            })
        
    }
    
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
