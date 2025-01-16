import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: WheelViewModel
    @Binding var isShowEditView: Bool
    @Binding var selectedSection: WheelSection?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("轉盤選項")){
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
                Section(header: Text("意見回饋")){
                    Link(destination: URL(string: "https://www.instagram.com/jimwu__/")!){
                        HStack{
                            Text("Instagram")
                            Spacer()
                            Image(systemName: "link").foregroundColor(.blue)
                        }
                    }.foregroundColor(.blue)
                }
                
                // section: donation
                Section(header: Text("其他"), footer: Text("目前僅支援Apple Pay")){
                    Button(action:{
                        // todo: apple pay
                    }) {
                        HStack{
                            Text("支持開發者")
                            Spacer()
                            Image(systemName: "heart.fill").foregroundColor(.pink)
                        }
                    }
                }
                
            }
                .navigationBarTitle("設定", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                    }
                ,
                trailing:
                    Button(action: {
                    selectedSection = nil
                    isShowEditView = true
                }) {
                    Image(systemName: "plus")
                }
            )
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
