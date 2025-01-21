import SwiftUI

struct Pointer: View {
    var pointerColor: Color
//    @State private var isShaking: Bool = false
    var isShaking: Bool

    var body: some View {
        ZStack {
            // 指針主體帶邊框
            Triangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [pointerColor, pointerColor.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    PointerTriangle()
                        .stroke(Color.white, lineWidth: 4) // 白色邊框
                )
                .frame(width: 40, height: 70) // 細長形
                .rotationEffect(.degrees(180))
                .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 3)
        }
        .rotationEffect(.degrees(isShaking ? -5 : 5), anchor: .top) // 抖動效果
        .animation(
            isShaking
                ? Animation.easeInOut(duration: 0.1).repeatForever(autoreverses: true)
                : .default,
            value: isShaking
        )
        // 測試用onAppear方便
//        .onAppear {
//            // 開始抖動
//            withAnimation {
//                isShaking = true
//            }
//        }
    }
}

// 自定義三角形形狀
struct PointerTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// 預覽
#Preview {
    Pointer(pointerColor: .red, isShaking: true)
}
