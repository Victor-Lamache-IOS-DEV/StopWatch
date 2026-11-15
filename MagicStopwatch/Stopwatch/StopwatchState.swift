import Foundation

enum StopwatchState: Equatable {
    case idle
    case running(startedAt: Date, accumulated: TimeInterval)
    case paused(accumulated: TimeInterval)
}
