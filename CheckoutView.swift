//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Ricardo on 05/03/24.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingAlert = false
    @State private var alertTitle = "Error"
    @State private var alertMessage = "There was an unexpected issue with your order."
    
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),
                           scale: 3) { image in
                        image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                .accessibilityHidden(true)
                    
                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank You!", isPresented: $showingConfirmation){
            Button("Ok") { }
        } message: {
            Text(confirmationMessage)
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK"){}
        } message: {
            Text(alertMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        //for testing pourposes
        let encodedString = String(decoding: encoded, as: UTF8.self)
            print("Encoded order: \(encodedString)")
        //
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!)"
            showingConfirmation = true
        } catch {
            print("Check out failed: \(error.localizedDescription)")
            alertTitle = "Order Failed"
            alertMessage = "Please check your internet connection and try again."
            showingAlert = true
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
