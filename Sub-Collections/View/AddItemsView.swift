//
//  AddItemsView.swift
//  Sub-Collections
//
//  Created by رنيم القرني on 17/10/1445 AH.
//

import SwiftUI

struct AddItemsView: View {
    @State var title: String = ""
    @State var info: String = ""
    @State var dueDate: Date = .now
    @State var timestamp: Date = .now
    var  category : Categories
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            Form{
                Section {
                    TextField("Title", text: $title)
                    TextField("Info", text: $info)
                    DatePicker(selection: $dueDate) {
                        Text("Due Date")
                    }
                }
                Button {
                    let item = Item(id: UUID().uuidString, title: title, detels: info , dudate: dueDate)
                    let cat = Categories(id: category.id, CategoryName: category.CategoryName , itemsCount: category.itemsCount+1)
                    Task{
                        try await firebaseManager.addItemToCategory(category:category , item:item)
                        try await firebaseManager.updatecategory(category: cat)
                        try await firebaseManager.fetchCategories()
                        try await firebaseManager.fetchItemsForCategory(category: category)
                        
                    }
                    dismiss()
                } label: {
                    Text("Add Item")
                }

                
            }.navigationTitle("Add Item")
        }
    }
}

#Preview {
    AddItemsView(category: Categories.init(id: "", CategoryName: "", itemsCount: 0))
}
