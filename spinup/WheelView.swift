//
//  SwiftUIView.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import SwiftUI

struct WheelView: View {
    var section: [WheelSection]
    
    var body: some View{
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<self.section.count, id \.self) { index in
                    self.drawSection(geometry: geometry, index: index)
                }
            }
            
        }
    }
    
    // draw section
    private func drawSection(geometry: GeometryProxy, index: int) -> some View {
        let angle = 360.0 / Double(section.count)
        let startAngle = angle * Double(index)
        let endAngle = startAngle + angle
        
        return ZStack {
            Path { path in
                let rect = geometry.frame(in: .local)
                let center = CGPoint(x: rect.midX, y: rect.midY)
                let redius = min(rect.width, rect.height) / 2
                path.move(to: center)
                path.addArc(center: ceter, radius: redius, startAngle: .degrees(startAngle), endAngle: .degrees(endAngle), clockwise: false)
                    .fill(section[index].color)
                Text(selection[index].title)
                    .position(self.textPosition(geometry:geometry, startAngle: startAngle, endAngle: endAngle))
                    .foregroundColor(.white)
            }
        }
    }
    
    private func textPosition(geometry: GeometryProxy, startAngle: Double, endAngle: Double) -> CGPoint {
        let midAngle = (startAngle+endAngle) / 2
        let redius = min(geometry.size.width, geometry.size.height) / 2
        let x = geometry.size.width/2 + redius * 0.7 * CGFloat(cos(midAngle * .pi / 180))
        let y = geometry.size.height / 2 + radius * 0.7 * CGFloat(sin(midAngle * .pi / 180))
        
        return CGPoint(x: x, y: y)
    }
}
