import SwiftUI

struct PixelWheelView: View {
    var sections: [WheelSection]
    var totalRotation: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景陰影
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [.gray.opacity(0.3), .black.opacity(0.8)]),
                            center: .center,
                            startRadius: 50,
                            endRadius: 200
                        )
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)

                // 轉盤區域
                ForEach(0..<sections.count, id: \.self) { index in
                    drawSection(geometry: geometry, index: index)
                }

                // 中心設計
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.yellow, .orange]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                    .overlay(
                        Text("SPIN")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    )
                    .shadow(radius: 5)
            }
        }
    }

    private func drawSection(geometry: GeometryProxy, index: Int) -> some View {
        let anglePerSection = 360.0 / Double(sections.count)
        let startAngle = anglePerSection * Double(index)
        let endAngle = startAngle + anglePerSection
        let sectionColor = sections[index].color

        return Path { path in
            let rect = geometry.frame(in: .local)
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2

            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(startAngle),
                endAngle: .degrees(endAngle),
                clockwise: false
            )
        }
        .fill(
            LinearGradient(
                gradient: Gradient(colors: [sectionColor, sectionColor.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            Text(sections[index].title)
                .font(.caption)
                .foregroundColor(.white)
                .rotationEffect(.degrees(-totalRotation)) // 保持文字正向
                .position(positionForText(geometry: geometry, startAngle: startAngle, endAngle: endAngle))
        )
    }

    private func positionForText(geometry: GeometryProxy, startAngle: Double, endAngle: Double) -> CGPoint {
        let midAngle = (startAngle + endAngle) / 2
        let radius = min(geometry.size.width, geometry.size.height) * 0.4
        let x = geometry.size.width / 2 + radius * CGFloat(cos(midAngle * .pi / 180))
        let y = geometry.size.height / 2 + radius * CGFloat(sin(midAngle * .pi / 180))
        return CGPoint(x: x, y: y)
    }
}
