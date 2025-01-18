//
//  SwiftUIView.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import SwiftUI

struct WheelView: View {
    var sections: [WheelSection]
    // 新增屬性, call WheelView(a, b) 直接新增參數 且再view定義型別就可以使用
    var totalRotation: Double // 新增的属性

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ZStack {
                    ForEach(0 ..< self.sections.count, id: \.self) { index in
                        self.drawSection(geometry: geometry, index: index)
                    }

                    // Custom center design with "Chu"
                    Text(":)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .top, endPoint: .bottom)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .blur(radius: 1)
                        )
                        .offset(y: -geometry.size.height / 2 + 188)
                }
            }
        }
    }

    private func drawSection(geometry: GeometryProxy, index: Int) -> some View {
        let anglePerSection = 360.0 / Double(sections.count)
        let startAngle = anglePerSection * Double(index)
        let endAngle = startAngle + anglePerSection

        return ZStack {
            Path { path in
                let rect = geometry.frame(in: .local)
                let center = CGPoint(x: rect.midX, y: rect.midY)
                let radius = min(rect.width, rect.height) / 2

                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: .degrees(startAngle), endAngle: .degrees(endAngle), clockwise: false)
            }
            .fill(sections[index].color)

            Text(sections[index].title)
                .rotationEffect(.degrees(-totalRotation)) // 使文字始终保持正面
                .position(self.textPosition(geometry: geometry, startAngle: startAngle, endAngle: endAngle))
                .foregroundColor(.white)
        }
    }

    private func textPosition(geometry: GeometryProxy, startAngle: Double, endAngle: Double) -> CGPoint {
        let midAngle = (startAngle + endAngle) / 2
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let x = geometry.size.width / 2 + radius * 0.7 * CGFloat(cos(midAngle * .pi / 180))
        let y = geometry.size.height / 2 + radius * 0.7 * CGFloat(sin(midAngle * .pi / 180))
        return CGPoint(x: x, y: y)
    }
}
