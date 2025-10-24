import CoreGraphics

enum OverlayUtils {
    static func screenRect(for bbox: CGRect, in size: CGSize) -> CGRect {
        let width = bbox.width * size.width
        let height = bbox.height * size.height
        let x = bbox.origin.x * size.width
        let y = bbox.origin.y * size.height
        return CGRect(x: x, y: y, width: width, height: height)
    }

    static func labelPosition(for bbox: CGRect, in size: CGSize) -> CGPoint {
        let rect = screenRect(for: bbox, in: size)
        return CGPoint(x: rect.midX, y: max(rect.minY - 24, 8))
    }
}
