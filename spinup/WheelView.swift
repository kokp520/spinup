//
//  SwiftUIView.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import SwiftUI

struct WheelSection:Identifiable {
    var id = UUID()
    var title: String
    var color: Color
}

struct WheelView: View {
    var sections: [WheelSection]
    // 新增屬性, call WheelView(a, b) 直接新增參數 且再view定義型別就可以使用
    var totalRotation: Double // 新增的属性
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ZStack {
                    ForEach(0..<self.sections.count, id: \.self) { index in
                        self.drawSection(geometry: geometry, index: index)
                    }
                }
//                SpinWheelPointer(pointerColor: model.pointerColor).offset(x: 0, y: -25)
            }
        }
    }
    
    private func drawSection(geometry: GeometryProxy, index: Int) -> some View {
        // 每個section的角度 360/幾個選擇
        let anglePerSection = 360.0 / Double(sections.count)
        
        // 開始的角度 看我的index是第幾個就從第幾個開始畫
        let startAngle = anglePerSection * Double(index)
        
        // 結束角度 就會是 開始的角度 加上每個選擇被分配的角度
        let endAngle = startAngle + anglePerSection
        
        return ZStack {
            // 定義繪圖的路徑
            Path { path in
                // view 框架
                let rect = geometry.frame(in: .local)
                // 中心點
                let center = CGPoint(x: rect.midX, y: rect.midY)
                // 半徑
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
