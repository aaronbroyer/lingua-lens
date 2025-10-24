import Foundation
import ARKit

final class VisionOCR {
    static let shared = VisionOCR()

    private var lastRun = Date.distantPast
    private let throttleInterval: TimeInterval = 1

    private init() {}

    func recognize(frame: ARFrame, store: Store) {
        guard Date().timeIntervalSince(lastRun) >= throttleInterval else { return }
        lastRun = Date()

        let snippets = mockSnippets()
        Task { @MainActor in
            snippets.forEach { store.ingestOCR(snippet: $0) }
        }
    }

    private func mockSnippets() -> [String] {
        let samples = ["Cafe", "Salida", "Caja"]
        return Array(samples.shuffled().prefix(3))
    }
}
