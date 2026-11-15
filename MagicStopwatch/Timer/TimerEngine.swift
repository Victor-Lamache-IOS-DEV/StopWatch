import Foundation
import Observation

@MainActor
@Observable
final class TimerEngine {
    private(set) var state: TimerState = .idle
    private(set) var duration: TimeInterval = 0
    private(set) var completionCount = 0
    private var completionTask: Task<Void, Never>?

    var isIdle: Bool {
        if case .idle = state { true } else { false }
    }

    var isRunning: Bool {
        if case .running = state { true } else { false }
    }

    func remaining(at date: Date = .now) -> TimeInterval {
        switch state {
        case .idle: 0
        case .running(let endDate): max(0, endDate.timeIntervalSince(date))
        case .paused(let remaining): remaining
        }
    }

    func start(duration: TimeInterval, at date: Date = .now) {
        guard duration > 0 else { return }
        self.duration = duration
        run(for: duration, at: date)
    }

    func pause(at date: Date = .now) {
        guard isRunning else { return }
        let left = remaining(at: date)
        completionTask?.cancel()
        state = .paused(remaining: left)
    }

    func resume(at date: Date = .now) {
        guard case .paused(let left) = state else { return }
        run(for: left, at: date)
    }

    func cancel() {
        completionTask?.cancel()
        state = .idle
    }

    private func run(for interval: TimeInterval, at date: Date) {
        completionTask?.cancel()
        state = .running(endDate: date.addingTimeInterval(interval))
        completionTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(interval))
            guard !Task.isCancelled else { return }
            self?.finish()
        }
    }

    private func finish() {
        state = .idle
        completionCount += 1
    }
}
