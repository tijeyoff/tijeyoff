import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Books")
                }

            CreateBookView()
                .tabItem {
                    Image(systemName: "plus.bubble")
                    Text("AI")
                }
        }
    }
}
