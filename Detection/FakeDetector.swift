import Foundation
import CoreGraphics

actor FakeDetector: Detecting {
    // TODO: Replace FakeDetector with a VNCoreMLRequest powered detector (e.g., YOLOv8n Core ML).
    private let sampleSets: [[Detection]] = [
        [
            Detection(
                id: UUID(),
                label: "cup",
                confidence: 0.92,
                bbox: CGRect(x: 0.45, y: 0.35, width: 0.15, height: 0.25)
            ),
            Detection(
                id: UUID(),
                label: "table",
                confidence: 0.88,
                bbox: CGRect(x: 0.2, y: 0.55, width: 0.6, height: 0.35)
            )
        ],
        [
            Detection(
                id: UUID(),
                label: "chair",
                confidence: 0.81,
                bbox: CGRect(x: 0.05, y: 0.45, width: 0.25, height: 0.4)
            ),
            Detection(
                id: UUID(),
                label: "plant",
                confidence: 0.78,
                bbox: CGRect(x: 0.7, y: 0.25, width: 0.2, height: 0.4)
            ),
            Detection(
                id: UUID(),
                label: "cup",
                confidence: 0.9,
                bbox: CGRect(x: 0.4, y: 0.4, width: 0.16, height: 0.24)
            )
        ]
    ]

    private var currentIndex = 0

    func detectOnce() async -> [Detection] {
        let detections = sampleSets[currentIndex]
        currentIndex = (currentIndex + 1) % sampleSets.count
        return detections
    }
}
