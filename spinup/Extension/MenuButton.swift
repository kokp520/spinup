import CoreHaptics
import SwiftUI

struct MenuButton: View {
    enum Style {
        case dots
        case text(String)
        case icon(String) // sf symbols
    }
    
    // note: 因為閉包跟尾隨閉包只能用一個 為什麼還要建立action呢
    @State private var engine: CHHapticEngine?
    let action: () -> Void // 1️⃣ 存儲用戶定義的動作
    let style: Style
    init(style: Style = .dots, action: @escaping () -> Void) {
        self.style = style
        self.action = action
    }
    
    @State private var hapticsPrepared = false
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        Button(action: {
            playHaptic() // 2️⃣ 先執行觸感
            action() // 3️⃣ 再執行用戶的動作
        }) {
            switch style {
            case .dots:
                Text(".")
            case .text(let label):
                Text(label)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            case .icon(let sf):
                Image(systemName: sf)
                    .font(.system(size: 25, weight: .medium))
                    .foregroundColor(.black)
            }
        }
        .padding(12)
        .buttonStyle(ScaleButtonStyle())
        .onAppear {
            prepareHaptics()
            generator.prepare()
        }
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        if hapticsPrepared { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            hapticsPrepared = true
        } catch {
            print("Haptics error: \(error.localizedDescription)")
        }
    }
    
    private func playHaptic() {
        generator.impactOccurred()
    }
}

// 添加按鈕縮放效果
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// 預覽
struct MenuButtonPreview: View {
    @State private var tapped = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(tapped ? "已點擊" : "未點擊")
            
            MenuButton {
                tapped.toggle()
            }
            
            MenuButton(style: .text("設定")) {
                tapped.toggle()
            }
        }
    }
}

#Preview("Interactive") {
    MenuButtonPreview()
        .padding()
}

#Preview("dark") {
    MenuButtonPreview()
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
}
