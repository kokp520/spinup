//
//  spinupApp.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import SwiftUI

@main
struct spinupApp: App {
//    @StateObject private var viewModel = WheelViewModel()
    var body: some Scene {
        WindowGroup {
//            TabView {
//                ContentView(viewModel: viewModel)
//                    .tabItem {
//                        Label("Home", systemImage: "house")
//                    }
//                    .preferredColorScheme(.light) // 強制整個應用為淺色模式

//                WheelListView(viewModel: viewModel)
//                    .tabItem {
//                        Label("Wheels", systemImage: "list.bullet")
//                    }
//
//                SettingsView()
//                    .tabItem {
//                        Label("Settings", systemImage: "gearshape")

            ContentView()
                .preferredColorScheme(.light) // 強制整個應用為淺色模式
        }
    }
}
