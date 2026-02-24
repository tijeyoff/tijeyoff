import SwiftUI

@main
struct AiBooksApp: App {
    @StateObject private var repository = BookRepository()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(repository)
        }
    }
}
