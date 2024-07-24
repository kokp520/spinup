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
                Section(header: Text("Option Details")) {
                    TextField("Title", text: $title)
                    ColorPicker("Color", selection: $color)
                }
                
                Button(action: save) {
                    Text("Save")
                }
            }
            .navigationBarTitle(section == nil ? "Add Option" : "Edit Option", displayMode: .inline)
            .onAppear {
                if let section = section {
                    title = section.title
                    color = section.color
                }
            }
        }
    }
    
    private func save() {
        if let section = section {
            viewModel.updateSection(id: section.id, title: title, color: color)
        } else {
            viewModel.addSection(title: title, color: color)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}
