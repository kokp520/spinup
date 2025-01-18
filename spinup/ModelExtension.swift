

import SwiftUI

@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension Color {
    static let spin_wheel_color: [Color] = [
        Color(hex: "FBE488"), // 移除驚嘆號
        Color(hex: "75AB53"),
        Color(hex: "D1DC59"),
        Color(hex: "EC9D42"),
        Color(hex: "DE6037"),
        Color(hex: "DA4533"),
        Color(hex: "992C4D"),
        Color(hex: "433589"),
        Color(hex: "4660A8"),
        Color(hex: "4291C8")
    ]

    // 修改 init 方法，不再返回可選型別
    init(hex: String, opacity: Double = 1.0) {
        var hex: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") { hex.remove(at: hex.startIndex) }

        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let b = Double(rgbValue & 0xff) / 255.0

        self.init(red: r, green: g, blue: b, opacity: opacity)
    }

    func toHex() -> String? {
        let uiColor = UIColor(self)
        guard let components = uiColor.cgColor.components else { return nil }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX",
                      lroundf(r * 255),
                      lroundf(g * 255),
                      lroundf(b * 255))
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct Triangle: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY), control1: CGPoint(x: rect.maxX, y: rect.minY), control2: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct SpinWheelPointer: View {
    var pointerColor: Color
    var body: some View {
        Triangle().frame(width: 50, height: 50)
            .foregroundColor(pointerColor).cornerRadius(24)
            .rotationEffect(.init(degrees: 180))
            .shadow(color: Color(hex: "212121", opacity: 0.5), radius: 5, x: 0.0, y: 1.0)
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct SpinWheelCell: Shape {
    let startAngle: Double, endAngle: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        let alpha = CGFloat(startAngle)
        let center = CGPoint(
            x: rect.midX,
            y: rect.midY
        )
        path.move(to: center)
        path.addLine(
            to: CGPoint(
                x: center.x + cos(alpha) * radius,
                y: center.y + sin(alpha) * radius
            )
        )
        path.addArc(
            center: center, radius: radius,
            startAngle: Angle(radians: startAngle),
            endAngle: Angle(radians: endAngle),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}
