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
            WheelView(section: section)
                .frame(width: 300, height: 300)
                .rotationEffect(.degrees(rotation))
            
            Button(action: spinWheel) {
                Text("Spin")
                    .font(.largeTitle)
                    .padding()
            }
        }
    }
    
    private func spinWheel() {
        withAnimation(.easeOut(duration: 5)) {
            rotation += 360 * 10
        }
    }
}

#Preview {
    ContentView()
}
