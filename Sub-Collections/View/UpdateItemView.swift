//
//  UpdateItemView.swift
//  Sub-Collections
//
//  Created by رنيم القرني on 17/10/1445 AH.
//

import SwiftUI

struct UpdateItemView: View {
    @State var title: String = ""
    @State var info: String = ""
    @State var dueDate: Date = .now
    @State var timestamp: Date = .now
    @State var isDone =  false
    var  category : Categories
    var  item : Item
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @Environment(\.dismiss) var dismiss
    var body: some View {
            Form{
                Section {
                    TextField("Title", text: $title)
                    TextField("Info", text: $info)
                    DatePicker(selection: $dueDate) {
                        Text("Due Date")
                    }
                    Toggle(isOn: $isDone) {
                        Text("is Done")
                    }
                    
                }
                Button(action: {
                    print("number1")
                    let item = Item(id:item.id , title: title, detels: info ,dudate: dueDate)
                    Task{
                        try await firebaseManager.updateItems(category: category ,item: item)
                        try await firebaseManager.fetchItemsForCategory(category: category)
                    }
                }, label: {
                    Text("Update Item")
                }).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ , alignment: .center)
                    .font(.title3)
                    .buttonStyle(.borderless)
                    .foregroundColor(.white)
                    .listRowBackground(Color.blue)
                
            }.navigationTitle("Update Item")
                .onAppear{
                    title = item.title
                    info = item.detels
                    isDone = item.isDine
                    dueDate = item.dudate
                    timestamp = item.timestamp
                }
        
    }
}

#Preview {
    UpdateItemView(category: Categories.init(id: "", CategoryName: "", itemsCount: 0), item: Item.init(id: "", title: "", detels: ""))
        .environmentObject(FirebaseManager())
}
