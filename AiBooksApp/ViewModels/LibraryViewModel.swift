import Foundation

@MainActor
final class LibraryViewModel: ObservableObject {
    @Published private(set) var books: [Book] = []

    func bind(repository: BookRepository) {
        books = repository.allBooksForLibrary
    }
}
