import Foundation

@MainActor
final class BookRepository: ObservableObject {
    @Published private(set) var books: [Book] = []

    private let storageKey = "ai_books_storage_v1"

    init() {
        load()
    }

    func add(_ book: Book) {
        books.insert(book, at: 0)
        save()
    }

    func replace(with generatedBooks: [Book]) {
        books = generatedBooks
        save()
    }

    var allBooksForLibrary: [Book] {
        let merged = books + Book.samples
        return Array(Set(merged)).shuffled()
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode([Book].self, from: data)
        else {
            books = []
            return
        }

        books = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(books) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
