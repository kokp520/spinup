//
//  WheelViewModel.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import Combine
import SwiftUI

class WheelViewModel: ObservableObject {
    @Published var sections: [WheelSection] = [
        WheelSection(title: "Option 1", color: .red),
        WheelSection(title: "Option 2", color: .blue),
        WheelSection(title: "Option 3", color: .green),
        WheelSection(title: "Option 4", color: .yellow)
    ]
    
    func addSection(title: String, color: Color) {
        sections.append(WheelSection(title: title, color: color))
    }
    
    func removeSection(at index: Int) {
        sections.remove(at: index)
    }
    
    func updateSection(id: UUID, title: String, color: Color) {
        if let index = sections.firstIndex(where: { $0.id == id }) {
            sections[index].title = title
            sections[index].color = color
        }
    }
}

