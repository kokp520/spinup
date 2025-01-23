import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WheelViewModel
    @Binding var section: WheelSection?

    @State private var title: String = ""
    @State private var color: Color = .init(
        red: Double.random(in: 0...1),
        green: Double.random(in: 0...1),
        blue: Double.random(in: 0...1)
    )

    @State private var logError: Bool = false

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
            .alert("提示", isPresented: $logError) {
                Button("確定", role: .cancel) {}
            } message: {
                Text("操作失敗，請稍後再試！")
            }
        }
    }

    private func save() {
        if let s = section {
            let updateModel = WheelSection(id: s.id, title: title, color: color)
            if !viewModel.updateSection(updateModel) {
                logError = true
            } else {
                dismiss()
            }
        }
    }
}
