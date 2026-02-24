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
        case invalidEndpoint
        case api(statusCode: Int, message: String)
        case emptyModelResponse
        case invalidResponseFormat(rawText: String)

        var errorDescription: String? {
            switch self {
            case .invalidAPIKey:
                return "Google AI API key qo'yilmagan. GeminiConfiguration.apiKey ni yangilang."
            case .invalidEndpoint:
                return "Gemini endpoint URL noto'g'ri."
            case let .api(statusCode, message):
                return "Gemini API xatosi (\(statusCode)): \(message)"
            case .emptyModelResponse:
                return "Gemini javobi bo'sh yoki bloklangan bo'lishi mumkin."
            case let .invalidResponseFormat(rawText):
                return "Gemini javobini JSON ga o'girishda xatolik. Raw: \(rawText.prefix(220))"
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
        guard let url = URL(string: endpoint) else {
            throw GeminiError.invalidEndpoint
        }

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

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw GeminiError.api(statusCode: -1, message: "HTTP response olinmadi")
        }

        if !(200...299).contains(http.statusCode) {
            let apiError = try? JSONDecoder().decode(GeminiAPIErrorResponse.self, from: data)
            let apiMessage = apiError?.error.message ?? String(data: data, encoding: .utf8) ?? "Noma'lum xatolik"
            throw GeminiError.api(statusCode: http.statusCode, message: apiMessage)
        }

        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
        let rawText = decoded.candidates
            .flatMap { $0.content.parts }
            .compactMap { $0.text }
            .joined(separator: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !rawText.isEmpty else {
            let reason = decoded.promptFeedback?.blockReason ?? "EMPTY"
            throw GeminiError.api(statusCode: http.statusCode, message: "Model text bo'sh. blockReason=\(reason)")
        }

        let normalized = Self.extractJSONObject(from: rawText)
        guard let jsonData = normalized.data(using: .utf8) else {
            throw GeminiError.invalidResponseFormat(rawText: rawText)
        }

        do {
            let generated = try JSONDecoder().decode(GeneratedBookPayload.self, from: jsonData)
            return Book(
                title: generated.title,
                summary: generated.summary,
                content: generated.content,
                genre: generated.genre,
                characters: generated.characters
            )
        } catch {
            throw GeminiError.invalidResponseFormat(rawText: rawText)
        }
    }

    private static func extractJSONObject(from text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.hasPrefix("```") {
            let withoutFenceStart = trimmed
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if withoutFenceStart.first == "{" && withoutFenceStart.last == "}" {
                return withoutFenceStart
            }
        }

        if let start = trimmed.firstIndex(of: "{"), let end = trimmed.lastIndex(of: "}") {
            return String(trimmed[start...end])
        }

        return trimmed
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

    struct PromptFeedback: Codable {
        let blockReason: String?
    }

    let candidates: [Candidate]
    let promptFeedback: PromptFeedback?
}

private struct GeminiAPIErrorResponse: Codable {
    struct ErrorPayload: Codable {
        let code: Int?
        let message: String
        let status: String?
    }

    let error: ErrorPayload
}

private struct GeneratedBookPayload: Codable {
    let title: String
    let summary: String
    let genre: String
    let characters: [String]
    let content: String
}
