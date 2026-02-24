import SwiftUI

struct BookDetailView: View {
    let book: Book

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(book.title)
                    .font(.largeTitle.bold())

                Text(book.summary)
                    .font(.headline)
                    .foregroundColor(.secondary)

                HStack {
                    Label(book.genre, systemImage: "tag")
                    Spacer()
                    Label(book.createdAt.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                }
                .font(.footnote)
                .foregroundColor(.secondary)

                if !book.characters.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Qahramonlar")
                            .font(.headline)

                        ForEach(book.characters, id: \.self) { character in
                            Text("• \(character)")
                        }
                    }
                }

                Divider()

                Text(book.content)
                    .font(.body)
                    .lineSpacing(6)
            }
            .padding()
        }
        .navigationTitle("Book")
        .navigationBarTitleDisplayMode(.inline)
    }
}
