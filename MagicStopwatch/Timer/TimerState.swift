import Foundation

enum TimerState: Equatable {
    case idle
    case running(endDate: Date)
    case paused(remaining: TimeInterval)
}
