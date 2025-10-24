import Foundation

enum LessonEngine {
    // TODO: Swap template generation with an on-device LLM (MLC-LLM / llama.cpp) that returns strict JSON.
    static func generate(_ snapshot: ContextSnapshot) async -> Lesson {
        let fallbackObject = snapshot.objects.first ?? "taza"
        let words = sampleWords()

        let labelMatchQuiz = QuizItem(
            id: UUID(),
            type: "label_match",
            prompt: "Toca la palabra que coincide con \(fallbackObject).",
            options: generateOptions(using: snapshot.objects, fallback: fallbackObject),
            answer: fallbackObject
        )

        let speakQuiz = QuizItem(
            id: UUID(),
            type: "speak",
            prompt: "Di en voz alta la palabra \"caf\u00e9\" (placeholder).",
            options: nil,
            answer: nil
        )

        let lessonText = "Practica vocabulario del caf\u00e9 con objetos cercanos y repasa frases cortas para consolidar la memoria en ambos idiomas."

        let metadata: [String: String] = [
            "locale": snapshot.locale,
            "level": snapshot.level,
            "sceneHint": snapshot.sceneHint ?? "unknown",
            "objectCount": "\(snapshot.objects.count)"
        ]

        return Lesson(
            words: words,
            lesson: lessonText,
            quiz: [labelMatchQuiz, speakQuiz],
            metadata: metadata
        )
    }

    private static func sampleWords() -> [WordItem] {
        return [
            WordItem(
                id: UUID(),
                lemma: "mostrador",
                article: "el",
                ipa: "mos.t\u027e a\u02c8\u00f0o\u027e",
                example: "Deja la taza en el mostrador."
            ),
            WordItem(
                id: UUID(),
                lemma: "caja",
                article: "la",
                ipa: "\u02c8ka.xa",
                example: "Paga en la caja antes de sentarte."
            ),
            WordItem(
                id: UUID(),
                lemma: "cucharita",
                article: "la",
                ipa: "ku.t\u0283a\u02c8\u027eti.ta",
                example: "Usa la cucharita para mezclar el caf\u00e9."
            )
        ]
    }

    private static func generateOptions(using objects: [String], fallback: String) -> [String] {
        var unique = Array(Set(objects))
        if !unique.contains(fallback) {
            unique.append(fallback)
        }
        while unique.count < 3 {
            unique.append(fallback)
        }
        return Array(unique.prefix(3))
    }
}
