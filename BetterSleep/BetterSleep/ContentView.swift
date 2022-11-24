//
//  ContentView.swift
//  BetterSleep
//
//  Created by Patrick Abele on 24.11.22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var selection = 1
    var arr = 1...20
        


    var body: some View {
        NavigationView {
            Form {
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?").font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden()
                    
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep").font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25) { _ in calculateBedtime() }
                }

                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake").font(.headline)
                    Picker("Please select our daily ration", selection: $selection) {
                        ForEach(1 ..< 20) {
                            Text($0 == 1 ? "1 cup" : "\($0) cups" )
                        }
                    }.onReceive([self].publisher.first()) {_ in calculateBedtime() }
                }
                
                VStack(alignment: .leading,spacing: 0) {
                    
                    Text("Your ideal bedtime is..." + alertMessage).font(.headline)
                }
            }
            .navigationTitle("Better Rest")
    
        }
    }
    
    func calculateBedtime(){
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(selection))
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)

        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        
        showingAlert = true

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

