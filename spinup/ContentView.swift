//
//  ContentView.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import SwiftUI

struct ContentView: View {
    
    // model
    @StateObject private var viewModel = WheelViewModel()
    // edit view
    @State private var isShowingAddEditView = false
    @State private var selectedSection: WheelSection?
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack {
            // custom wheel view
            WheelView(sections: viewModel.sections, totalRotation: rotation)
                .frame(width: 300, height: 380)
                .rotationEffect(.degrees(rotation))
            
            SpinWheelPointer(pointerColor: .red)
                .frame(width: 20, height: 100)
                .offset(y: -100)
            
            // button to spin
            Button(action: spinWheel) {
                Text("Spin")
                    .font(.largeTitle)
                    .padding()
            }
            
            // model and edit view
            HStack {
                Button(action: {
                    selectedSection = nil
                    isShowingAddEditView = true
                }) {
                    Text("Add Option")
                        .font(.title2)
                        .padding()
                }

                
                Button(action: saveOptions) {
                    Text("Save Options")
                        .font(.title2)
                        .padding()
                }
            }
            
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
                            Text("編輯")
                                .cornerRadius(5) // Optional: Make the button look nicer
                        }
                        .padding(.trailing)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            if let index = viewModel.sections.firstIndex(where: { $0.id == section.id }) {
                                viewModel.removeSection(at: index)
                            }
                        }) {
                            Text("刪除")
                                .cornerRadius(5) // Optional: Make the button look nicer
                        }
                        .buttonStyle(BorderlessButtonStyle()) // button邊界
                    }
                    .padding(.vertical, 10) // 增加垂直方向上的間距
                }
            }
            .sheet(isPresented: $isShowingAddEditView) {
               EditView(viewModel: viewModel, section: $selectedSection)
            }
        }
    }
    
    private func spinWheel() {
        withAnimation(.easeOut(duration: 2)) {
            rotation += Double.random(in: 1800...3600)
        }
        
        // calculate selected section after spinning
        let normalizedRotaion = rotation.truncatingRemainder(dividingBy: 360)
        let sectionCount = viewModel.sections.count
        let degreesPerSection = 360.0 / Double(sectionCount)
        let selectedSectionIndex = Int((360 - normalizedRotaion) / degreesPerSection) % sectionCount
        selectedSection = viewModel.sections[selectedSectionIndex + 1]
    }
    
    private func saveOptions() {
        print("Options saved: \(viewModel.sections)")
    }
}

#Preview {
    ContentView()
}
