//
//  Sub_CollectionsApp.swift
//  Sub-Collections
//
//  Created by رنيم القرني on 17/10/1445 AH.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
@main
struct Sub_CollectionsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firebaseManager = FirebaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FirebaseManager())
        }
    }
}
