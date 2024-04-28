import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Categories: Codable , Identifiable {
    let id: String
    var CategoryName: String
    var itemsCount: Int = 0
}

struct Item: Codable , Identifiable {
    let id: String
    var title: String
    var detels: String
    var isDine: Bool = false
    var dudate: Date = .now
    var timestamp: Date = .now
}

class FirebaseManager: NSObject , ObservableObject {
    @Published var categories: [Categories] = []
    @Published var categoriesWithItems: [String: [Item]] = [:] // Dictionary to hold items for each category
    let firestore: Firestore
    
    override init() {
        self.firestore = Firestore.firestore()
    }
    
    func createCategory(category: Categories) async throws {
        do {
            try firestore.collection("Categories").document(category.id).setData(from: category)
            print("sacsess")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchCategories() async throws {
        let querySnapshot = try await firestore.collection("Categories").getDocuments()
        /// decode the fetching data to be in the same form of my bilud object
        /// this slice of code  $0.data(as: Item.self)  convert dictinary into object
        let items = querySnapshot.documents.compactMap({try? $0.data(as: Categories.self)})
        DispatchQueue.main.async {
            self.categories = items
        }
    }
    
    func updatecategory(category: Categories) async throws {
        do{
            try  firestore.collection("Categories").document(category.id).setData(from: category)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func deletcategory(category: Categories) async throws {
        do{
            try await firestore.collection("Categories").document(category.id).delete()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func addItemToCategory(category: Categories , item: Item) async throws {
        do {
            try firestore.collection("Categories").document(category.id).collection("items").document(item.id).setData(from: item)
            print("sacsess2")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchItemsForCategory(category: Categories) async throws {
        do {
            let querySnapshot = try await firestore.collection("Categories").document(category.id).collection("items").getDocuments()
            let items = querySnapshot.documents.compactMap { document -> Item? in
                do {
                    return try document.data(as: Item.self)
                } catch {
                    print("Error decoding item document:", error)
                    return nil
                }
            }
            DispatchQueue.main.async {
                // Update the dictionary with the fetched items for the specific category
                self.categoriesWithItems[category.id] = items
            }
            print("Success: Items fetched for category \(category.CategoryName)")
        } catch {
            print("Error fetching items for category \(category.CategoryName):", error.localizedDescription)
            throw error // Re-throw the error to handle it in the caller
        }
    }
    
    func updateItems(category: Categories ,item: Item) async throws {
        do{
            try  firestore.collection("Categories").document(category.id).collection("items").document(item.id).setData(from: item)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func deletItems(category: Categories ,item: Item) async throws {
        do{
            try await firestore.collection("Categories").document(category.id).collection("items").document(item.id).delete()
        }catch{
            print(error.localizedDescription)
        }
        
    }

    
}
