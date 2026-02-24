import Foundation

@MainActor
final class CreateBookViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(text: "Kayfiyatingiz qanday? Qanaqa kitob o'qishni xohlaysiz?", sender: .assistant)
    ]
    @Published var inputText: String = ""
    @Published var isLoading = false
    @Published var errorText: String?

    let quickPrompts: [String] = [
        "Romantik hikoya",
        "Fantasy sarguzasht",
        "Qisqa motivatsion asar",
        "Drama va taqdir"
    ]

    private let geminiService = GeminiService()

    func usePrompt(_ prompt: String) {
        inputText = prompt
    }

    func send(repository: BookRepository) async {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isLoading else { return }

        errorText = nil
        isLoading = true
        messages.append(ChatMessage(text: trimmed, sender: .user))
        inputText = ""

        do {
            let book = try await geminiService.generateBook(from: trimmed)
            repository.add(book)
            messages.append(ChatMessage(text: "Tayyor! \(book.title) kitobi yaratildi 📘", sender: .assistant))
        } catch {
            let fallback = "AI bilan ulanishda muammo: \(error.localizedDescription)"
            errorText = fallback
            messages.append(ChatMessage(text: fallback, sender: .assistant))
        }

        isLoading = false
    }
}
