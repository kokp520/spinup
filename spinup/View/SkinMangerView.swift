//import SwiftUI
//
//struct SkinManagerView: View {
//    @ObservedObject var viewModel: WheelViewModel
//    @State private var selectedWheel: WheelModel?
//
//    var body: some View {
//        VStack {
//            // 上方顯示選中的大型轉盤
//            if let selectedWheel = selectedWheel {
//                VStack {
//                    PixelWheelView(sections: selectedWheel.sections, totalRotation: 0, isShaking: false)
//                        .frame(width: 200, height: 200)
//                        .padding()
//
//                    Text(selectedWheel.name)
//                        .font(.headline)
//                        .padding(.bottom, 10)
//
//                    Button(action: {
//                        viewModel.setActiveWheel(selectedWheel)
//                    }) {
//                        Text("Use")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                            .padding(.horizontal)
//                    }
//                }
//            } else {
//                Text("Select a wheel")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//            }
//
//            Divider()
//                .padding(.vertical)
//
//            // 下方顯示小方格的輪盤選項
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 20) {
//                    ForEach(viewModel.wheels) { wheel in
//                        VStack {
//                            PixelWheelView(sections: wheel.sections, totalRotation: 0, isShaking: false)
//                                .frame(width: 80, height: 80)
//                                .onTapGesture {
//                                    selectedWheel = wheel
//                                }
//
//                            Text(wheel.name)
//                                .font(.caption)
//                                .lineLimit(1)
//                        }
//                        .padding()
//                        .background(selectedWheel?.id == wheel.id ? Color.blue.opacity(0.2) : Color.clear)
//                        .cornerRadius(10)
//                    }
//                }
//                .padding(.horizontal)
//            }
//        }
//        .padding()
//        .navigationTitle("Skin Manager")
//    }
//}
//
//#Preview {
//    // Mock ViewModel with sample data
//    let mockViewModel = WheelViewModel()
//    mockViewModel.wheels = [
//        WheelModel(name: "Classic", sections: [WheelSection(title: "A", color: .red), WheelSection(title: "B", color: .blue)]),
//        WheelModel(name: "Modern", sections: [WheelSection(title: "X", color: .green), WheelSection(title: "Y", color: .purple)]),
//        WheelModel(name: "Retro", sections: [WheelSection(title: "1", color: .yellow), WheelSection(title: "2", color: .orange)])
//    ]
//
//    return SkinManagerView(viewModel: mockViewModel)
//}
import SwiftUI

struct SkinManagerView: View {
    @ObservedObject var viewModel: WheelViewModel
    @State private var selectedWheelIndex: Int = 0 // 当前选中的轮盘索引

    // 模拟的轮盘数据，用于演示多轮盘切换
    private let wheels = [
        (name: "Classic Wheel", sections: [
            WheelSection(id: UUID(), title: "Prize 1", color: .red),
            WheelSection(id: UUID(), title: "Prize 2", color: .blue),
            WheelSection(id: UUID(), title: "Prize 3", color: .green)
        ]),
        (name: "Rainbow Wheel", sections: [
            WheelSection(id: UUID(), title: "Gold", color: .yellow),
            WheelSection(id: UUID(), title: "Silver", color: .gray),
            WheelSection(id: UUID(), title: "Bronze", color: .brown)
        ]),
        (name: "Mystery Wheel", sections: [
            WheelSection(id: UUID(), title: "Secret 1", color: .purple),
            WheelSection(id: UUID(), title: "Secret 2", color: .orange),
            WheelSection(id: UUID(), title: "Secret 3", color: .pink)
        ]),
        (name: "Rainbow Wheel", sections: [
            WheelSection(id: UUID(), title: "Gold", color: .yellow),
            WheelSection(id: UUID(), title: "Silver", color: .gray),
            WheelSection(id: UUID(), title: "Bronze", color: .brown)
        ])
    ]

    var body: some View {
        VStack {
            // 当前选中轮盘的展示
            VStack {
                Text("Selected Wheel: \(wheels[selectedWheelIndex].name)")
                    .font(.headline)
                    .padding(.bottom, 10)

                PixelWheelView(
                    sections: wheels[selectedWheelIndex].sections,
                    totalRotation: 0, // 这里没有旋转逻辑，仅用于展示
                    isShaking: false
                )
                .frame(width: 200, height: 200)
            }
            .padding()

            // 轮盘选择列表
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(wheels.indices, id: \.self) { index in
                        VStack {
                            PixelWheelView(
                                sections: wheels[index].sections,
                                totalRotation: 0,
                                isShaking: false
                            )
                            .frame(width: 100, height: 100)
                            .background(Circle().stroke(index == selectedWheelIndex ? Color.blue : Color.gray, lineWidth: 2))

                            Text(wheels[index].name)
                                .font(.caption)

                            Button("Use") {
                                // 切换到选中的轮盘
                                selectedWheelIndex = index
                                viewModel.sections = wheels[index].sections
                            }
                            .font(.footnote)
                            .padding(.top, 5)
                        }
                        .padding(.horizontal, 5)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Skin Manager")
    }
}

#Preview {
    SkinManagerView(viewModel: WheelViewModel())
}

