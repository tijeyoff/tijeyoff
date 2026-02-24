import Foundation

struct ChatMessage: Identifiable, Hashable {
    enum Sender {
        case user
        case assistant
    }

    let id: UUID
    let text: String
    let sender: Sender
    let timestamp: Date

    init(id: UUID = UUID(), text: String, sender: Sender, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.sender = sender
        self.timestamp = timestamp
    }
}
