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

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            HStack {
                MenuButton(style: .icon("plus")) {
                    selectedSection = nil
                    activeSheet = .edit
                }
                .padding(.leading)

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

//                WheelView(sections: viewModel.sections, totalRotation: rotation)
//                    .frame(width: 300, height: 380)
//                    .rotationEffect(.degrees(rotation))
//                    .offset(y: Config.Wheel.offset)
                // level 2
                PixelWheelView(sections: viewModel.sections, totalRotation: rotation)
                    .frame(width: 300, height: 380)
                    .rotationEffect(.degrees(rotation))
                    .offset(y: Config.Wheel.offset)

                SpinWheelPointer(pointerColor: .red)
                    .frame(width: 20, height: 100)
                    .offset(y: -150 + Config.Wheel.offset)
            }

            Button(action: spinWheel) {
                Text("Spin up")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .frame(width: Config.Button.width, height: Config.Button.height)
                    .background(.black)
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
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
        let randomRotation = Double.random(in: 1800 ... 3600)

        withAnimation(.easeOut(duration: 2)) {
            rotation += randomRotation
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            audioPlayer?.stop()
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
