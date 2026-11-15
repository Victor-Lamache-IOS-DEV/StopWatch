import SwiftUI

struct StopwatchView: View {
    @State private var engine = StopwatchEngine()
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            TimelineView(.animation(paused: !engine.isRunning)) { context in
                Text(TimeFormatting.stopwatch(engine.elapsed(at: context.date)))
                    .font(.system(size: 80, weight: .thin))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                    .onTapGesture(count: 3) { showSettings = true }
            }
            .padding(.top, 48)
            .padding(.horizontal, 24)

            GlassEffectContainer(spacing: 40) {
                HStack {
                    ClockControlButton(title: engine.isRunning ? "Lap" : "Reset", tint: .gray) {
                        if engine.isRunning { engine.lap() } else { engine.reset() }
                    }

                    Color.clear
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .contentShape(.rect)
                        .onLongPressGesture { engine.force.isArmed.toggle() }

                    ClockControlButton(title: engine.isRunning ? "Stop" : "Start", tint: engine.isRunning ? .red : .green) {
                        if engine.isRunning { engine.stop() } else { engine.start() }
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(.vertical, 28)
            .sensoryFeedback(.impact, trigger: engine.laps.count)

            List(engine.laps) { lap in
                LapRowView(lap: lap, tint: tint(for: lap))
            }
            .listStyle(.plain)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .sheet(isPresented: $showSettings) {
            MagicSettingsView(engine: engine)
        }
    }

    private func tint(for lap: Lap) -> Color {
        if lap.id == engine.fastestLapID { return .green }
        if lap.id == engine.slowestLapID { return .red }
        return .primary
    }
}
