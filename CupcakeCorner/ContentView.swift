//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Ricardo on 29/02/24.
//

import SwiftUI

struct ContentView: View {
    //only place where order object is created.
    @State private var order = Order()
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    Picker("Select your cale", selection: $order.type) {
                        ForEach(Order.types.indices, id:\.self){
                            Text(Order.types[$0])
                        }
                    }
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section{
                    Toggle("Any special request?", isOn: $order.specialRequestEnabled.animation())
                    if order.specialRequestEnabled{
                        Toggle("Add extra frosting",isOn: $order.extraFrosting)
                        
                        Toggle("Add extra sprinkles",isOn: $order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink("Delivery details"){
                        AdressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
