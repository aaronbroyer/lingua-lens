import Foundation

@MainActor
final class Store: ObservableObject {
    @Published var detections: [Detection] = []
    @Published var ocrSnippets: [String] = []
    @Published var currentLesson: Lesson?
    @Published var lessons: [Lesson] = []  // TODO: Persist to SQLite (GRDB) with SRS (SM-2).

    private let detector: any Detecting
    private var detectionTask: Task<Void, Never>?

    init(detector: any Detecting = FakeDetector()) {
        self.detector = detector
        startDetectionLoop()
    }

    deinit {
        detectionTask?.cancel()
    }

    func buildLesson(locale: String = "en-US", level: String = "beginner", sceneHint: String? = "cafe") {
        let snapshot = ContextSnapshot(
            locale: locale,
            level: level,
            sceneHint: sceneHint,
            objects: detections.map(\.label),
            ocr: Array(ocrSnippets.prefix(3))
        )

        Task { [weak self] in
            let lesson = await LessonEngine.generate(snapshot)
            await MainActor.run {
                self?.currentLesson = lesson
            }
        }
    }

    func completeCurrentLesson() {
        guard let lesson = currentLesson else { return }
        lessons.append(lesson)
        currentLesson = nil
    }

    func ingestOCR(snippet: String) {
        guard !snippet.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        if let existingIndex = ocrSnippets.firstIndex(of: snippet) {
            let snippet = ocrSnippets.remove(at: existingIndex)
            ocrSnippets.insert(snippet, at: 0)
        } else {
            ocrSnippets.insert(snippet, at: 0)
            if ocrSnippets.count > 3 {
                ocrSnippets = Array(ocrSnippets.prefix(3))
            }
        }
    }

    private func startDetectionLoop() {
        let detector = self.detector
        detectionTask = Task.detached(priority: .background) { [weak self] in
            while !Task.isCancelled {
                let batch = await detector.detectOnce()
                await MainActor.run {
                    self?.detections = batch
                }
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }
}
