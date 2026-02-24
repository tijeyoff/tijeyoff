import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var repository: BookRepository
    @StateObject private var viewModel = LibraryViewModel()

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.books) { book in
                        NavigationLink(value: book) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(book.genre.uppercased())
                                    .font(.caption2.weight(.bold))
                                    .foregroundColor(.secondary)

                                Text(book.title)
                                    .font(.headline)
                                    .lineLimit(2)

                                Text(book.summary)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)

                                Spacer(minLength: 0)
                            }
                            .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Global AI Books")
            .onAppear {
                viewModel.bind(repository: repository)
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
        }
    }
}
