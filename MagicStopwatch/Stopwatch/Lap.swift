import Foundation

struct Lap: Identifiable, Sendable {
    let id = UUID()
    let number: Int
    let lapTime: TimeInterval
    let totalTime: TimeInterval
}
