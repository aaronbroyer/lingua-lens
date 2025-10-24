import Foundation

protocol Detecting {
    func detectOnce() async -> [Detection]
}
