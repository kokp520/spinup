//
//  SpinWheelSection.swift
//  spinup
//
//  Created by adi on 2025/1/17.
//

import SwiftUI

class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let spinWheelsKey = "savedSpinWheels"
    
    func saveWheel(_ wheel: SpinWheelData) {
        var savedWheels = getAllWheel()
        savedWheels.append(wheel)
        
        if let encoded = try? JSONEncoder().encode(savedWheels) {
            userDefaults.set(encoded, forKey: spinWheelsKey)
        }
    }
    
    func getAllWheel() -> [SpinWheelData] {
        guard let data = userDefaults.data(forKey: spinWheelsKey),
              let savedWheels = try? JSONDecoder().decode([SpinWheelData].self, from: data)
        else {
            return []
        }
        return savedWheels
    }

    func deleteWheel(at index: Int) {
        var savedWheel = getAllWheel()
        guard index < savedWheel.count else { return }
        
        savedWheel.remove(at: index)
        if let encoded = try? JSONEncoder().encode(savedWheel) {
            userDefaults.set(encoded, forKey: spinWheelsKey)
        }
    }
    
    func updateWheel(_ wheel: SpinWheelData, at index: Int) {
        var all = getAllWheel()
        guard index < all.count else { return }
        
        all[index] = wheel
        if let e = try? JSONEncoder().encode(all) {
            userDefaults.set(e, forKey: spinWheelsKey)
        }
    }
}
