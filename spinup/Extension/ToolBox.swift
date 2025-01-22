//
//  ToolBox.swift
//  spinup
//
//  Created by adi on 2025/1/22.
//

import SwiftUI

class ToolBox: ObservableObject {
    @Published var isShowingAlert = false
    @Published var title = ""
    @Published var color: Color = .red
    @Published var alertTitle = ""
    
    let viewModel: WheelViewModel
    var section: WheelSection?
    var onDismiss: (() -> Void)?
    
    init(viewModel: WheelViewModel) {
        self.viewModel = viewModel
    }
    
    func add() -> Alert {
        title = ""
        color = Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
        alertTitle = "新增項目"
        
        return Alert(
            title: Text(alertTitle),
            message: nil,
            primaryButton: .default(Text("確定")) {
                let newSection = WheelSection(
                    id: UUID(),
                    title: self.title,
                    color: self.color
                )
                self.viewModel.addSection(newSection)
                self.onDismiss?()
            },
            secondaryButton: .cancel(Text("取消"))
        )
    }
    
    func edit(section: WheelSection) -> Alert {
        self.section = section
        title = section.title
        color = section.color
        alertTitle = "編輯項目"
        
        return Alert(
            title: Text(alertTitle),
            message: nil,
            primaryButton: .default(Text("確定")) {
                let updatedSection = WheelSection(
                    id: section.id,
                    title: self.title,
                    color: self.color
                )
                self.viewModel.updateSection(updatedSection)
                self.onDismiss?()
            },
            secondaryButton: .cancel(Text("取消"))
        )
    }
}

//#Preview {
//    ToolBox()
//}
