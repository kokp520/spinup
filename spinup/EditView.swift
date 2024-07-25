//
//  edit view.swift
//  spinup
//
//  Created by adi on 2024/7/24.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WheelViewModel
    @Binding var section: WheelSection?
    
    @State private var title: String = ""
    @State private var color: Color = .red
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("optional detail")) {
                    TextField("Title", text: $title)
                    ColorPicker("Color", selection: $color)
                }
                
                Button(action: save) {
                    Text("儲存")
                }
            }
            .navigationBarTitle(section == nil ? "Add Option" : "Edit Option", displayMode: .inline)
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
            print("[debug]save...")
            let updateModel = WheelSection(id: s.id, title: title, color: color)
            viewModel.updateSection(updateModel)
        } else {
            let newModel = WheelSection(id: UUID(), title: title, color: color)
            viewModel.addSection(newModel)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}
