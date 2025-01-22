import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: WheelViewModel
    @Binding var isShowEditView: Bool
    @Binding var selectedSection: WheelSection?
    @Environment(\.dismiss) var dismiss

    @StateObject private var form = FormViewModel()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("轉盤選項")) {
                    ForEach(viewModel.sections) { section in
                        HStack {
                            Text(section.title)
                                .foregroundStyle(section.color)

                            Spacer()

                            // 編輯按鈕
                            Button(action: {
                                selectedSection = section
                                isShowEditView = true
                            }) {
                                Text("編輯")
                                    .foregroundStyle(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .padding(.horizontal, 8)

                            // 刪除按鈕
                            Button(action: {
                                if let index = viewModel.sections.firstIndex(where: { $0.id == section.id }) {
                                    viewModel.removeSection(at: index)
                                }
                            }) {
                                Text("刪除")
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(.vertical, 10)
                    }
                }

                // section: Contact
                Section(header: Text("意見回饋")) {
                    Link(destination: URL(string: "https://www.instagram.com/jimwu__/")!) {
                        HStack {
                            Text("Instagram")
                            Spacer()
                            Image(systemName: "link").foregroundColor(.blue)
                        }
                    }.foregroundColor(.blue)
                }

                // section: donation
                Section(header: Text("其他"), footer: Text("目前僅支援Apple Pay")) {
                    Button(action: {
                        // TODO: apple pay
                        showApplePayAlert()
                    }) {
                        HStack {
                            Text("支持開發者").foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "heart.fill").foregroundColor(.pink)
                        }
                    }
                }
            }
            .navigationBarTitle("設定", displayMode: .inline)
            .navigationBarItems(
                leading: MenuButton(style: .text("返回")) {
                    dismiss()
                },

                trailing:
                MenuButton(style: .text("新增")) {
                    form.reset()
                    form.isShowingAlert = true
                    selectedSection = nil
                }.alert("新增項目", isPresented: $form.isShowingAlert) {
                    TextField("名稱", text: $form.title)
                    Button("取消", role: .cancel) {}
                    Button("確定") {
                        let newSection = form.createSection()
                        viewModel.addSection(newSection)
                    }
                }
            )
        }
    }

    func showApplePayAlert() {
        // 獲取目前的最上層UIViewController，兼容iOS 15+
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController
        {
            let alert = UIAlertController(
                title: "提醒",
                message: "Apple Pay 支援服務商尚未開放, 你的支持我收到了",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))

            // 顯示提示框
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
}

#Preview {
    ListView(
        viewModel: WheelViewModel(),
        isShowEditView: .constant(false),
        selectedSection: .constant(nil)
    )
}
