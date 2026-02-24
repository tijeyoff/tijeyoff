import Foundation

struct GeminiConfiguration {
    // TODO: O'zingizning Google AI API key'ingizni shu yerga qo'ying.
    // Masalan: static let apiKey = "AIza..."
    static let apiKey = "PUT_YOUR_GOOGLE_AI_API_KEY_HERE"
    static let model = "gemini-1.5-flash"
}

struct GeminiService {
    enum GeminiError: Error, LocalizedError {
        case invalidAPIKey
        case invalidResponse

        var errorDescription: String? {
            switch self {
            case .invalidAPIKey:
                return "Google AI API key qo'yilmagan. GeminiConfiguration.apiKey ni yangilang."
            case .invalidResponse:
                return "Google AI'dan kutilgan javob kelmadi."
            }
        }
    }

    func generateBook(from userPrompt: String) async throws -> Book {
        guard GeminiConfiguration.apiKey != "PUT_YOUR_GOOGLE_AI_API_KEY_HERE" else {
            throw GeminiError.invalidAPIKey
        }

        let systemPrompt = """
        You are a creative novelist assistant.
        Return ONLY valid JSON with fields:
        {
          "title": "string",
          "summary": "string",
          "genre": "string",
          "characters": ["string"],
          "content": "long story text"
        }
        Keep story rich, coherent, and user-specific.
        """

        let finalPrompt = """
        User idea: \(userPrompt)

        Write an engaging Uzbek-friendly story/novella with emotional arc.
        """

        let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(GeminiConfiguration.model):generateContent?key=\(GeminiConfiguration.apiKey)"
        guard let url = URL(string: endpoint) else { throw GeminiError.invalidResponse }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = GeminiRequest(
            contents: [
                .init(role: "user", parts: [.init(text: systemPrompt)]),
                .init(role: "user", parts: [.init(text: finalPrompt)])
            ]
        )

        request.httpBody = try JSONEncoder().encode(payload)

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)

        guard let text = decoded.candidates.first?.content.parts.first?.text else {
            throw GeminiError.invalidResponse
        }

        let jsonData = Data(text.utf8)
        let generated = try JSONDecoder().decode(GeneratedBookPayload.self, from: jsonData)

        return Book(
            title: generated.title,
            summary: generated.summary,
            content: generated.content,
            genre: generated.genre,
            characters: generated.characters
        )
    }
}

private struct GeminiRequest: Codable {
    struct Content: Codable {
        let role: String
        let parts: [Part]
    }

    struct Part: Codable {
        let text: String
    }

    let contents: [Content]
}

private struct GeminiResponse: Codable {
    struct Candidate: Codable {
        struct Content: Codable {
            struct Part: Codable {
                let text: String?
            }

            let parts: [Part]
        }

        let content: Content
    }

    let candidates: [Candidate]
}

private struct GeneratedBookPayload: Codable {
    let title: String
    let summary: String
    let genre: String
    let characters: [String]
    let content: String
}
