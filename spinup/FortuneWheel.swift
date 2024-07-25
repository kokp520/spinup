//
//  fortuneWheel.swift
//  spinup
//
//  Created by adi on 2024/7/25.
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension Color {
    static let spin_wheel_color: [Color] = [
        Color(hex: "FBE488"), Color(hex: "75AB53"),
        Color(hex: "D1DC59"), Color(hex: "EC9D42"),
        Color(hex: "DE6037"), Color(hex: "DA4533"),
        Color(hex: "992C4D"), Color(hex: "433589"),
        Color(hex: "4660A8"), Color(hex: "4291C8")
    ]
    
    init(hex: String, alpha: Double = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        
        let scanner = Scanner(string: cString)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(.sRGB, red: Double(r) / 0xff, green: Double(g) / 0xff, blue:  Double(b) / 0xff, opacity: alpha)
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
            .rotationEffect(.init(degrees: 0))
            .shadow(color: Color(hex: "212121", alpha: 0.5), radius: 5, x: 0.0, y: 1.0)
    }
}

