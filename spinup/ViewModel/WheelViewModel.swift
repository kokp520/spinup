//
//  WheelViewModel.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import Combine
import SwiftUI

class WheelViewModel: ObservableObject {
//    @Published var sections: [WheelSection] = [
//        WheelSection(title: "Prize 0", color: Color.spin_wheel_color[0]),
//        WheelSection(title: "Prize 1", color: Color.spin_wheel_color[1]),
//        WheelSection(title: "Prize 2", color: Color.spin_wheel_color[2]),
//        WheelSection(title: "Prize 3", color: Color.spin_wheel_color[3]),
//        WheelSection(title: "Prize 4", color: Color.spin_wheel_color[4])
//    ]
    @Published var sections: [WheelSection] = []

    private let userDefaults = UserDefaults.standard
    private let sectionsKey = "WheelSections"

    init() {
        loadSections()
    }

    private func loadSections() {
        if let data = userDefaults.data(forKey: sectionsKey),
           let decodedData = try? JSONDecoder().decode([WheelSection].self, from: data)
        {
            sections = decodedData
        } else {
            let defaultSections = [
                WheelSection(id: UUID(), title: "PRIZE 1", color: .spin_wheel_color[0]),
                WheelSection(id: UUID(), title: "PRIZE 2", color: .spin_wheel_color[1]),
                WheelSection(id: UUID(), title: "PRIZE 3", color: .spin_wheel_color[2])
            ]
            sections = defaultSections
            saveSections()
        }
    }

    private func saveSections() {
        if let encoded = try? JSONEncoder().encode(sections) {
            userDefaults.set(encoded, forKey: sectionsKey)
        }
    }
    
    // other
    // 資料驗證
    private func isValid(_ section: WheelSection) -> Bool {
        return !section.title.isEmpty
    }

    // 帶有驗證的新增方法
    func addSection(_ section: WheelSection) -> Bool {
        guard isValid(section) else { return false }
        sections.append(section)
        saveSections()
        return true
    }

    // 帶有限制的更新方法
    func updateSection(_ section: WheelSection) -> Bool {
        guard isValid(section) else { return false }
        if let index = sections.firstIndex(where: { $0.id == section.id }) {
            sections[index] = section
            saveSections()
            return true
        }
        return false
    }

    // 安全的刪除方法
    func removeSection(at index: Int) -> Bool {
        guard index >= 0 && index < sections.count else { return false }
        sections.remove(at: index)
        saveSections()
        return true
    }
}
