import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.sender == .assistant {
                bubble
                Spacer(minLength: 40)
            } else {
                Spacer(minLength: 40)
                bubble
            }
        }
    }

    private var bubble: some View {
        Text(message.text)
            .padding(12)
            .foregroundColor(message.sender == .assistant ? .primary : .white)
            .background(message.sender == .assistant ? Color(.systemGray6) : Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
