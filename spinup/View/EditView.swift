//
//  edit view.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WheelViewModel
    @Binding var section: WheelSection?

    @State private var title: String = ""
    @State private var color: Color = .red

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("設定")) {
                    TextField("名稱", text: $title)
                    ColorPicker("顏色", selection: $color)
                }

                Button(action: save) {
                    Text("儲存")
                }
            }
            .navigationBarTitle(section == nil ? "新增" : "編輯", displayMode: .inline)
            .navigationBarItems(
                leading: MenuButton(style: .text("返回")) {
                    dismiss()
                })
            .onAppear {
                if let s = section {
                    title = s.title
                    color = s.color
                }
            }
        }
    }

    private func save() {
        if let s = section {
            let updateModel = WheelSection(id: s.id, title: title, color: color)
            viewModel.updateSection(updateModel)
        } else {
            let newModel = WheelSection(id: UUID(), title: title, color: color)
            viewModel.addSection(newModel)
        }

        dismiss()
    }
}
