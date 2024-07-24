//
//  ContentView.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var rotation: Double = 0
    
    let section: [WheelSection] = [
        WheelSection(title: "option 1", color: .red),
        WheelSection(title: "opt 2", color: .green),
        WheelSection(title: "opt 3", color: .blue),
        WheelSection(title: "opt 2", color: .yellow),
    ]
    
    var body: some View {
        VStack {
            // custom wheel view
            WheelView(sections: section, totalRotation: rotation)
                .frame(width: 300, height: 380)
                .rotationEffect(.degrees(rotation))
            
            // button to spin
            Button(action: spinWheel) {
                Text("Spin")
                    .font(.largeTitle)
                    .padding()
            }
        }
    }
    
    private func spinWheel() {
        withAnimation(.easeOut(duration: 2)) {
            rotation += Double.random(in: 1800...3600)
        }
    }
}

#Preview {
    ContentView()
}
