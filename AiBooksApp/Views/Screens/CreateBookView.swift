import SwiftUI

struct CreateBookView: View {
    @EnvironmentObject private var repository: BookRepository
    @StateObject private var viewModel = CreateBookViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("AI Book Creator")
                .font(.title2.bold())

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.quickPrompts, id: \.self) { prompt in
                        Button(prompt) {
                            viewModel.usePrompt(prompt)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
            }

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.messages) { message in
                        ChatBubble(message: message)
                    }

                    if viewModel.isLoading {
                        HStack {
                            ProgressView()
                            Text("AI kitob yozmoqda...")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
            }

            HStack(spacing: 8) {
                TextField("Kitob g'oyangizni yozing...", text: $viewModel.inputText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)

                Button {
                    Task {
                        await viewModel.send(repository: repository)
                    }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 30))
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
        .padding(.top)
    }
}
