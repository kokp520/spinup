//
//  WheelSection.swift
//  spinup
//
//  Created by adi on 2025/1/18.
//

import SwiftUI


struct WheelSection: Codable, Identifiable {
    let id: UUID
    var title: String
    var color: Color
    
    init(id: UUID = UUID(), title: String, color: Color) {
        self.id = id
        self.title = title
        self.color = color
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, colorHex
    }
    
    
    // 自定義實現, TODO: 這邊目前還是沒有很明白
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(color.toHex() ?? "#FF0000", forKey: .colorHex)
    }
    
    // from 後面不用: , 原因待查 差別 TODO:
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        let hex = try container.decode(String.self, forKey: .colorHex)
        color = Color(hex: hex)
    }
}
