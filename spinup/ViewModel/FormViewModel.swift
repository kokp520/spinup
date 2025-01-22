//
//  FormViewModel.swift
//  spinup
//
//  Created by adi on 2025/1/22.
//

import SwiftUI

class FormViewModel: ObservableObject {
    @Published var isShowingAlert = false
    @Published var title = ""
    @Published var color: Color = .random()

    func reset() {
        title = ""
        color = .random()
    }

    func createSection() -> WheelSection {
        WheelSection(
            id: UUID(),
            title: title,
            color: color
        )
    }
}

