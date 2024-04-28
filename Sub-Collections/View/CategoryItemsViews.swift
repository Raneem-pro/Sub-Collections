//
//  CategoryItemsViews.swift
//  Sub-Collections
//
//  Created by رنيم القرني on 17/10/1445 AH.
//

import SwiftUI

struct CategoryItemsViews: View {
    var  category : Categories
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @State private var isShowingAddingItemsView = false
    var body: some View {
        List {
                         ForEach(firebaseManager.categoriesWithItems[category.id] ?? []) { item in
                             NavigationLink {
                                 UpdateItemView(category: category, item: item)
                             } label: {
                                 Text(item.title)
                             }.swipeActions(edge: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/ , allowsFullSwipe: true){
                                 Button(action: {
                                     let cat = Categories(id: category.id, CategoryName: category.CategoryName , itemsCount: category.itemsCount-1)
                                     Task{
                                         try await firebaseManager.deletItems(category: category , item: item)
                                         try await firebaseManager.fetchItemsForCategory(category: category)
                                         try await firebaseManager.updatecategory(category: cat)
                                         try await firebaseManager.fetchCategories()
                                     }
                                 }, label: {
                                     Image(systemName: "trash")
                                 }).tint(.red)
                             }

                         }
                 }.navigationTitle("\(category.CategoryName)")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        isShowingAddingItemsView.toggle()
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }.sheet(isPresented:$isShowingAddingItemsView){
                AddItemsView(category: category)
            }
            .onAppear {
                     Task {
                         for category in firebaseManager.categories {
                             try await firebaseManager.fetchItemsForCategory(category: category)
                         }
                     }
                 }
    }
}

#Preview {
    CategoryItemsViews(category:Categories.init(id: "", CategoryName: "", itemsCount: 0))
        .environmentObject(FirebaseManager())
}
