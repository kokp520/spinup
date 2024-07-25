//
//  ContentView.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import SwiftUI
import AVFoundation // Audio player

struct ContentView: View {
    
    // model
    @StateObject private var viewModel = WheelViewModel()
    // edit view
    @State private var isShowingAddEditView = false
    @State private var isShowListView = true
    @State private var selectedSection: WheelSection?
    @State private var rotation: Double = 0
    
    // audio player
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack {
            // model and edit view
            HStack {
                Button(action: {
                    selectedSection = nil
                    isShowingAddEditView = true
                }) {
                    Text("+")
                        .font(.title2)
                        .padding()
                }
                .padding(.leading)
                Spacer()
                Button(action: {isShowListView.toggle()}) {
                    Text("...")
                        .font(.title2)
                        .padding()
                }
                .padding(.trailing)
            }
            .padding(.top)
            Spacer()
            // custom wheel view
            ZStack {
                // 陰影
                Circle()
                    .fill(Color.black.opacity(0.2))
                    .frame(width: 340, height: 320) // Adjust the size as needed
                    .shadow(radius: 99) // Adjust the shadow radius as needed
                    .blur(radius: 10)
                    .offset(y: 10) // Move shadow slightly downwards
                
                WheelView(sections: viewModel.sections, totalRotation: rotation)
                    .frame(width: 300, height: 380)
                    .rotationEffect(.degrees(rotation))
                
                SpinWheelPointer(pointerColor: .red)
                    .frame(width: 20, height: 100)
                    .offset(y: -150)
            }
            
            // button to spin
            Button(action: spinWheel) {
                Text("SPIN")
                    .font(.largeTitle)
                    .padding()
            }
            
            if isShowListView {
                listView()
                    .transition(.slide)
                    .sheet(isPresented: $isShowingAddEditView) {
                       EditView(viewModel: viewModel, section: $selectedSection)
                    }
            }
        }
        .onAppear(){
            loadSound()
        }
        .background(
            Image("cat")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.2)
        )
    }
    
    private func loadSound() {
        guard let soundURL = Bundle.main.url(forResource: "spin", withExtension: "wav") else {
            print("无法找到音频文件")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1 // 循环播放
        } catch {
            print("初始化音频播放器失败: \(error)")
        }
    }

    
    private func spinWheel() {
        // Play sound
        audioPlayer?.currentTime = 0 // 重置音效播放位置
        audioPlayer?.play()
        // Generate a random rotation amount
        let randomRotation = Double.random(in: 1800...3600)
        
        // Calculate the final rotation angle for the animation
//        let startRotation = rotation.truncatingRemainder(dividingBy: 360)
//        let endRotation = (startRotation + randomRotation).truncatingRemainder(dividingBy: 360)
        
        // Animate the rotation
        withAnimation(.easeOut(duration: 2)) {
            rotation += randomRotation
        }
        
        // Calculate the selected section after spinning
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
//            let sectionCount = viewModel.sections.count
//            let degreesPerSection = 360.0 / Double(sectionCount)
//            
//            // Calculate the angle for 90 degrees offset
//            let offsetAngle = (rotation - startRotation).truncatingRemainder(dividingBy: 360)
//            
//            let selectedSectionIndex = Int(offsetAngle / degreesPerSection) % sectionCount
//            
//            // Update selected section
//            selectedSection = viewModel.sections[selectedSectionIndex]
//            print("select index: \(selectedSectionIndex)")
//            print("選到了: \(String(describing: selectedSection!.title))")
            
            audioPlayer?.stop()
        }
        

    }
    
    private func saveOptions() {
        print("Options saved: \(viewModel.sections)")
    }
    
    // 目前的列表view
    @ViewBuilder
    private func listView() -> some View {
        List {
            ForEach(viewModel.sections){ section in
                HStack {
                    Text(section.title)
                        .foregroundStyle(section.color)
                    Spacer()
                    
                    Button(action: {
                        selectedSection = section
                        isShowingAddEditView = true
                    }){
                        Text("編輯").cornerRadius(5) // Optional: Make the button look nicer
                    }
                    .padding(.trailing)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Button(action: {
                        if let index = viewModel.sections.firstIndex(where: { $0.id == section.id }) {
                            viewModel.removeSection(at: index)
                        }
                    }) {
                        Text("刪除").cornerRadius(5) // Optional: Make the button look nicer
                    }
                    .buttonStyle(BorderlessButtonStyle()) // button邊界
                }
                .padding(.vertical, 10) // 增加垂直方向上的間距
            }
        }
    }
}

#Preview {
    ContentView()
}
