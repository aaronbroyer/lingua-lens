import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var store: Store

    func makeCoordinator() -> Coordinator {
        Coordinator(store: store)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Nothing to update for now.
    }

    final class Coordinator: NSObject, ARSessionDelegate {
        private weak var store: Store?

        init(store: Store) {
            self.store = store
        }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            guard let store else { return }
            VisionOCR.shared.recognize(frame: frame, store: store)
        }
    }
}
