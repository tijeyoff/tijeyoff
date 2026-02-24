# AI Books (iPhone Native SwiftUI)

Bu loyiha iPhone uchun **native SwiftUI** asosida tayyorlangan konsept app:

- `Library` tab: AI yaratgan kitoblar ro'yxati (global + user generated).
- `Create` tab: chatga o'xshash interfeys orqali AI bilan gaplashib hikoya/roman/kitob yaratish.
- Google AI (Gemini) API uchun tayyor servis qatlami (`GeminiService`) qo'shilgan.
- API key va endpoint joyi aniq belgilangan, siz o'zingiz key qo'shib ishga tushirasiz.

- Tayyor `AiBooksApp.xcodeproj` ham qo'shildi, Xcode'da to'g'ridan-to'g'ri ochib ishlatishingiz mumkin.


## Arxitektura

- `Models`: `Book`, `ChatMessage`
- `Services`: `GeminiService`, `BookRepository`
- `ViewModels`: `CreateBookViewModel`, `LibraryViewModel`
- `Views`: `Library` va `Create` ekranlari, `BookDetail` ekrani

## Google AI API ulash

`AiBooksApp/Services/GeminiService.swift` ichida:

1. `GeminiConfiguration.apiKey` ga key qo'ying.
2. Xohlasangiz `gemini-1.5-flash` modelini o'zgartiring.
3. Prompt JSON qurilishi tayyor, response parse ham kiritilgan.

## Eslatma

Bu repo hozircha source-level scaffold holatda. Uni Xcode'da iOS App target bilan ochib, shu fayllarni targetga qo'shishingiz mumkin.

Taklif: keyinchalik quyidagilarni qo'shish:

- Voice-over (AVSpeechSynthesizer)
- Audiobook export
- Cloud sync
- User auth + personal library
