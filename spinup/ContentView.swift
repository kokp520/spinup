import AVFoundation
import SwiftUI

enum ActiveSheet: Identifiable {
    case list
    case edit

    var id: Int {
        switch self {
        case .list: return 0
        case .edit: return 1
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = WheelViewModel()
    @State private var activeSheet: ActiveSheet?
    @State private var selectedSection: WheelSection?
    @State private var rotation: Double = 0
    @State private var audioPlayer: AVAudioPlayer?
    @State private var spinButtonPressed = false

//    @State private var isShowingAlert = false
//    @State private var newTitle = ""
//    @State private var newColor: Color = .random()
    @StateObject private var formViewModel = FormViewModel()

    @State private var isShaking: Bool = false

//    private var wheelForm: FormUtilities.WheelForm {
//        FormUtilities.WheelForm(title: $newTitle, color: $newColor)
//    }

    @State private var logError: Bool = false

    var body: some View {
        VStack {
            HStack {
                MenuButton(style: .icon("plus")) {
                    formViewModel.reset()
                    selectedSection = nil
                    formViewModel.isShowingAlert = true
                }
                .padding(.leading)
                .alert("新增項目", isPresented: $formViewModel.isShowingAlert) {
                    TextField("名稱", text: $formViewModel.title)
                    Button("取消", role: .cancel) {}
                    Button("確定") {
                        let newSection = formViewModel.createSection()
                        if !viewModel.addSection(newSection) {
                            logError = true
                        }
                    }
                }
                .alert("提示", isPresented: $logError) {
                    Button("確認", role: .cancel) {}
                } message: { Text("操作失敗，請稍後再試！") }

                Spacer()

                MenuButton(style: .icon("slider.horizontal.3")) {
                    activeSheet = .list
                }
                .padding(.trailing)
            }
            .padding(.top)

            Spacer()

            ZStack {
                // 陰影
                Circle()
                    .fill(Color.black.opacity(0.2))
                    .frame(width: 340, height: 320)
                    .shadow(radius: 99)
                    .blur(radius: 10)
                    .offset(y: Config.Wheel.offset)

                PixelWheelView(sections: viewModel.sections, totalRotation: rotation, isShaking: isShaking)
                    .frame(width: 300, height: 380)
                    .rotationEffect(.degrees(rotation))
                    .offset(y: Config.Wheel.offset)

                // 其他種wheel
                WheelView(sections: viewModel.sections, totalRotation: rotation, isShaking: isShaking)
                    .frame(width: 300, height: 380)
                    .rotationEffect(.degrees(rotation))
                    .offset(y: Config.Wheel.offset)

                Pointer(pointerColor: .red, isShaking: isShaking)
                    .frame(width: 20, height: 100)
                    .offset(y: -150 + Config.Wheel.offset)
            }

            Button(action: spinWheel) {
                Text("Spin up")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .frame(width: Config.Button.width, height: Config.Button.height)
                    .background(ZStack {
                        Color.black // 按鈕底色
                        RoundedRectangle(cornerRadius: Config.Button.cornerRadius)
                            .stroke(.white, lineWidth: 10) // 貼紙風格白邊框
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 5, y: 5) // 邊框陰影
                    })
                    .cornerRadius(Config.Button.cornerRadius)
                    .shadow(
                        color: .black.opacity(0.3),
                        radius: Config.Button.shadowRadius,
                        x: 0,
                        y: 3
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Config.Button.cornerRadius)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
            }
            .offset(y: Config.Button.offset)
            .scaleEffect(spinButtonPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3), value: spinButtonPressed)
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .list:
                ListView(
                    viewModel: viewModel,
                    isShowEditView: Binding(
                        get: { activeSheet == .edit },
                        set: { if $0 { activeSheet = .edit } else { activeSheet = nil } }
                    ),
                    selectedSection: $selectedSection
                )
            case .edit:
                EditView(viewModel: viewModel, section: $selectedSection)
            }
        }
        .onAppear {
            loadSound()
        }
    }

    private func loadSound() {
        guard let soundURL = Bundle.main.url(forResource: "spin", withExtension: "wav") else {
            print("Error: Cannot found soundurl")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1
        } catch {
            print("Error: Init audio failed: \(error)")
        }
    }

    private func spinWheel() {
        isShaking = true
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
        let randomRotation = Double.random(in: 1800 ... 3600)

        withAnimation(.easeOut(duration: 2)) {
            rotation += randomRotation
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            audioPlayer?.stop()
            isShaking = false
        }
    }
}

#Preview {
    ContentView()
}
