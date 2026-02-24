import Foundation

struct Book: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var summary: String
    var content: String
    var genre: String
    var characters: [String]
    var createdAt: Date
    var isGlobalSample: Bool

    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        content: String,
        genre: String,
        characters: [String],
        createdAt: Date = Date(),
        isGlobalSample: Bool = false
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
        self.genre = genre
        self.characters = characters
        self.createdAt = createdAt
        self.isGlobalSample = isGlobalSample
    }
}

extension Book {
    static let samples: [Book] = [
        Book(
            title: "Taqdir Yo'li",
            summary: "Sevgi, orzu va taqdir to'qnashgan emotsional hikoya.",
            content: "Bu sample matn. To'liq hikoya AI orqali generate qilinadi.",
            genre: "Romance",
            characters: ["Lola", "Aziz"],
            isGlobalSample: true
        ),
        Book(
            title: "Neon Shahar Sirlari",
            summary: "Kelajak shahrida yo'qolgan xotiralar va katta sir.",
            content: "Bu sample matn. To'liq hikoya AI orqali generate qilinadi.",
            genre: "Sci-Fi",
            characters: ["Mira", "Unit-7"],
            isGlobalSample: true
        ),
        Book(
            title: "Sukunatdagi Ovoz",
            summary: "Qadimiy qishloqda topilgan kundalik hammasini o'zgartiradi.",
            content: "Bu sample matn. To'liq hikoya AI orqali generate qilinadi.",
            genre: "Mystery",
            characters: ["Saida", "Iskandar"],
            isGlobalSample: true
        )
    ]
}
