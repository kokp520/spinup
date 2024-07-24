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
    
    // routaion
    @State private var rotation: Double = 0
    
//    let section: [WheelSection] = [
//        WheelSection(title: "option 1", color: .red),
//        WheelSection(title: "opt 2", color: .green),
//        WheelSection(title: "opt 3", color: .blue),
//        WheelSection(title: "opt 2", color: .yellow),
//    ]
    
    var body: some View {
        VStack {
            // custom wheel view
            WheelView(sections: viewModel.sections, totalRotation: rotation)
                .frame(width: 300, height: 380)
                .rotationEffect(.degrees(rotation))
            
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
                        
                        Button("Edit"){
                            selectedSection = section
                            isShowingAddEditView = true
                        }
                        .padding(.trailing)
                        
                        Button("Delete") {
                        if let index = viewModel.sections.firstIndex(where: { $0.id == section.id }) {
                            viewModel.removeSection(at: index)
                        }
                    }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingAddEditView) {
           EditView(viewModel: viewModel, section: $selectedSection)
       }
    }
    
    private func spinWheel() {
        withAnimation(.easeOut(duration: 2)) {
            rotation += Double.random(in: 1800...3600)
        }
    }
    
    private func saveOptions() {
        // 在这里实现保存选项的逻辑，比如保存到文件或用户默认设置
        print("Options saved: \(viewModel.sections)")
    }
}

#Preview {
    ContentView()
}
