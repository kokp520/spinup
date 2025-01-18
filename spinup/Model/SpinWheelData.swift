//
//  SpinWheelData.swift
//  spinup
//
//  Created by adi on 2025/1/17.
//

import SwiftUI

struct SectionData: Codable {
    var title: String
    var color: String
}

struct SpinWheelData: Codable {
    var data: [SectionData]
    var name: String
    var createdDate: Date
}
