import Foundation
import CoreGraphics

struct Detection: Identifiable {
    let id: UUID
    let label: String
    let confidence: Float
    let bbox: CGRect   // normalized 0...1
}

struct ContextSnapshot: Codable {
    var locale: String
    var level: String
    var sceneHint: String?
    var objects: [String]
    var ocr: [String]
}

struct WordItem: Codable, Identifiable {
    let id: UUID
    var lemma: String
    var article: String?
    var ipa: String?
    var example: String
}

struct QuizItem: Codable, Identifiable {
    let id: UUID
    var type: String
    var prompt: String
    var options: [String]?
    var answer: String?
}

struct Lesson: Codable {
    var words: [WordItem]
    var lesson: String
    var quiz: [QuizItem]
    var metadata: [String: String]
}
