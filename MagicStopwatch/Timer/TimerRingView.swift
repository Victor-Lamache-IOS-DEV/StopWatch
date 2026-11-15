import SwiftUI

struct TimerRingView: View {
    let engine: TimerEngine

    var body: some View {
        TimelineView(.animation(minimumInterval: 0.1, paused: !engine.isRunning)) { context in
            let remaining = engine.remaining(at: context.date)
            let progress = engine.duration > 0 ? remaining / engine.duration : 0
            ZStack {
                Circle()
                    .stroke(.quaternary, style: StrokeStyle(lineWidth: 12))
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(.orange, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text(TimeFormatting.countdown(remaining))
                    .font(.system(size: 60, weight: .thin))
                    .monospacedDigit()
            }
            .frame(width: 280, height: 280)
            .frame(maxWidth: .infinity)
        }
    }
}
