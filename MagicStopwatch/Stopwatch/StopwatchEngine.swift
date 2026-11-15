import Foundation
import Observation

@MainActor
@Observable
final class StopwatchEngine {
    private(set) var state: StopwatchState = .idle
    private(set) var laps: [Lap] = []
    var force = MagicForce()

    var isRunning: Bool {
        if case .running = state { true } else { false }
    }

    var fastestLapID: Lap.ID? {
        laps.count >= 2 ? laps.min { $0.lapTime < $1.lapTime }?.id : nil
    }

    var slowestLapID: Lap.ID? {
        laps.count >= 2 ? laps.max { $0.lapTime < $1.lapTime }?.id : nil
    }

    func elapsed(at date: Date = .now) -> TimeInterval {
        switch state {
        case .idle: 0
        case .running(let startedAt, let accumulated): accumulated + date.timeIntervalSince(startedAt)
        case .paused(let accumulated): accumulated
        }
    }

    func start(at date: Date = .now) {
        switch state {
        case .idle:
            state = .running(startedAt: date, accumulated: 0)
        case .paused(let accumulated):
            state = .running(startedAt: date, accumulated: accumulated)
        case .running:
            return
        }
    }

    func stop(at date: Date = .now) {
        guard isRunning else { return }
        var final = elapsed(at: date)
        if force.isArmed, let digits = force.finalDigits {
            final = MagicForce.apply(digits, to: final)
        }
        state = .paused(accumulated: final)
    }

    func lap(at date: Date = .now) {
        guard isRunning else { return }
        let total = elapsed(at: date)
        var split = total - (laps.first?.totalTime ?? 0)
        if force.isArmed, let digits = force.nextLapDigits() {
            split = MagicForce.apply(digits, to: split)
        }
        laps.insert(Lap(number: laps.count + 1, lapTime: split, totalTime: total), at: 0)
    }

    func reset() {
        state = .idle
        laps = []
        force.resetLapSequence()
    }
}
