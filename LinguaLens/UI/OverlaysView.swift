import SwiftUI

struct OverlaysView: View {
    @EnvironmentObject private var store: Store

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                ForEach(store.detections) { detection in
                    overlay(for: detection, in: proxy.size)
                }

                if let snippet = store.ocrSnippets.first {
                    ocrPill(snippet: snippet, safeTop: proxy.safeAreaInsets.top, width: proxy.size.width)
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func overlay(for detection: Detection, in size: CGSize) -> some View {
        let percent = Int((detection.confidence * 100).rounded())
        let position = OverlayUtils.labelPosition(for: detection.bbox, in: size)

        return Text("\(detection.label.capitalized) - \(percent)%")
            .font(.callout).bold()
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.65))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            .position(position)
            .shadow(radius: 4)
    }

    private func ocrPill(snippet: String, safeTop: CGFloat, width: CGFloat) -> some View {
        Text("Seen text: \(snippet)")
            .font(.footnote)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.9))
            .clipShape(Capsule())
            .shadow(radius: 3)
            .position(x: width / 2, y: safeTop + 30)
    }
}
