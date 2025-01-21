import SwiftUI

struct WheelView: View {
    var sections: [WheelSection]
    var totalRotation: Double
    var isShaking: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景陰影（環繞轉盤）
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [.black.opacity(0.8), .gray.opacity(0.2)]),
                            center: .center,
                            startRadius: 50,
                            endRadius: geometry.size.width / 2
                        )
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .shadow(color: .black.opacity(0.6), radius: 15, x: 0, y: 10)

                // 轉盤區域
                ForEach(0 ..< sections.count, id: \.self) { index in
                    drawSection(geometry: geometry, index: index)
                }

                // 轉盤的光澤效果
                Circle()
                    .stroke(
                        RadialGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.6), Color.clear]),
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: geometry.size.width / 1.5
                        ),
                        lineWidth: 20
                    )
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.9)

                // 中心設計（立體感+反光）
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [.yellow, .orange]),
                            center: .center,
                            startRadius: 10,
                            endRadius: geometry.size.width * 0.15
                        )
                    )
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white.opacity(0.7), .clear]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 5
                            )
                    )
                    .overlay(
                        Text("SPIN")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 5)
                    .rotationEffect(isShaking ? .degrees(90) : .degrees(0)) // 微抖動
                    .animation(
                        isShaking ? Animation.easeInOut(duration: 0.1).repeatForever(autoreverses: true) : .default,
                        value: isShaking
                    )
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

struct WheelView_Previews: PreviewProvider {
    static var previews: some View {
        WheelView(
            sections: [
                WheelSection(title: "Section 1", color: .red),
                WheelSection(title: "Section 2", color: .blue),
                WheelSection(title: "Section 3", color: .green),
                WheelSection(title: "Section 4", color: .purple)
            ],
            totalRotation: 150,
            isShaking: true
        )
        .frame(width: 300, height: 300)
    }
}
