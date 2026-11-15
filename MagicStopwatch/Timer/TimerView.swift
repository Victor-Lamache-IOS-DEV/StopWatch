import SwiftUI

struct TimerView: View {
    @State private var engine = TimerEngine()
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0

    private var pickedDuration: TimeInterval {
        TimeInterval(hours * 3600 + minutes * 60 + seconds)
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            if engine.isIdle {
                DurationPickerView(hours: $hours, minutes: $minutes, seconds: $seconds)
            } else {
                TimerRingView(engine: engine)
            }

            Spacer()

            GlassEffectContainer(spacing: 40) {
                HStack {
                    ClockControlButton(title: "Cancel", tint: .gray) {
                        engine.cancel()
                    }
                    .disabled(engine.isIdle)

                    Spacer()

                    primaryButton
                }
                .padding(.horizontal, 40)
            }
            .padding(.bottom, 32)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .sensoryFeedback(.success, trigger: engine.completionCount)
    }

    @ViewBuilder
    private var primaryButton: some View {
        if engine.isRunning {
            ClockControlButton(title: "Pause", tint: .orange) {
                engine.pause()
            }
        } else if engine.isIdle {
            ClockControlButton(title: "Start", tint: .green) {
                engine.start(duration: pickedDuration)
            }
            .disabled(pickedDuration == 0)
        } else {
            ClockControlButton(title: "Resume", tint: .green) {
                engine.resume()
            }
        }
    }
}
