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
           WheelSection(title: "Prize 1", color: Color.spin_wheel_color[0]),
           WheelSection(title: "Prize 2", color: Color.spin_wheel_color[1]),
           WheelSection(title: "Prize 3", color: Color.spin_wheel_color[2]),
           WheelSection(title: "Prize 4", color: Color.spin_wheel_color[3]),
           WheelSection(title: "Prize 5", color: Color.spin_wheel_color[4])
       ]

       func addSection(_ section: WheelSection) {
           sections.append(section)
       }

       func updateSection(_ section: WheelSection) {
           if let index = sections.firstIndex(where: { $0.id == section.id }) {
               sections[index] = section
           }
       }

       func removeSection(at index: Int) {
           sections.remove(at: index)
       }
}

