import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @State private var isShowingAddCategoryView = false
    @State private var selectedCategory: Categories?
    var body: some View {
        NavigationView{
            List{
                ForEach(firebaseManager.categories){ category in
                    NavigationLink {
                        CategoryItemsViews(category: category)
                    } label: {
                        HStack {
                            Text(category.CategoryName)
                            Text("(\(category.itemsCount))")
                            Spacer()
                            Menu {
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Label("Edit", systemImage: "square.and.pencil")
                                }
                                Button(action: {
                                    Task {
                                        try await firebaseManager.deletcategory(category: category)
                                        try? await firebaseManager.fetchCategories()
                                    }
                                }) {
                                    Label("Delete", systemImage: "trash")
                                        .foregroundColor(.red)
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal.circle")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }

                    
                }
            }.navigationTitle("To Do")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isShowingAddCategoryView.toggle()
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                }.sheet(isPresented: $isShowingAddCategoryView){
                    AddCategoryView()
                }
                .sheet(item: $selectedCategory) { category in
                    UpdateCategoryView(category: category)
                }
        }
        .onAppear {
            Task {
                try await firebaseManager.fetchCategories()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirebaseManager())
    }
}
