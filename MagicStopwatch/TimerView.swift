import SwiftUI

struct TimerView: View {
    @State private var hours = 0
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var totalDuration: TimeInterval = 0
    @State private var endDate: Date?
    @State private var pausedRemaining: TimeInterval?

    private var isActive: Bool { endDate != nil || pausedRemaining != nil }

    var body: some View {
        VStack {
            if isActive {
                runningView
            } else {
                pickers
            }

            GlassEffectContainer {
                HStack {
                    Button(action: cancel) {
                        Text("Cancel")
                            .font(.body)
                            .frame(width: 80, height: 80)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .tint(.gray)
                    .disabled(!isActive)

                    Spacer()

                    if endDate != nil {
                        Button(action: pause) {
                            Text("Pause")
                                .font(.body)
                                .frame(width: 80, height: 80)
                        }
                        .buttonStyle(.glassProminent)
                        .buttonBorderShape(.circle)
                        .tint(.orange)
                    } else {
                        Button(action: start) {
                            Text(pausedRemaining == nil ? "Start" : "Resume")
                                .font(.body)
                                .frame(width: 80, height: 80)
                        }
                        .buttonStyle(.glassProminent)
                        .buttonBorderShape(.circle)
                        .tint(.green)
                        .disabled(hours + minutes + seconds == 0)
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 24)
        }
        .navigationTitle("Timer")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var pickers: some View {
        HStack(spacing: 0) {
            wheel($hours, range: 0..<24, unit: "hours")
            wheel($minutes, range: 0..<60, unit: "min")
            wheel($seconds, range: 0..<60, unit: "sec")
        }
        .frame(height: 260)
    }

    private func wheel(_ selection: Binding<Int>, range: Range<Int>, unit: String) -> some View {
        HStack(spacing: 4) {
            Picker(unit, selection: selection) {
                ForEach(range, id: \.self) { Text("\($0)").tag($0) }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            Text(unit)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var runningView: some View {
        TimelineView(.periodic(from: .now, by: 0.1)) { context in
            let remaining = remainingTime(at: context.date)
            let fraction = totalDuration > 0 ? remaining / totalDuration : 0
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.2), style: StrokeStyle(lineWidth: 12))
                Circle()
                    .trim(from: 0, to: fraction)
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text(format(remaining))
                    .font(.system(size: 60, weight: .thin))
                    .monospacedDigit()
            }
            .frame(width: 280, height: 280)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func remainingTime(at date: Date) -> TimeInterval {
        if let endDate { return max(0, endDate.timeIntervalSince(date)) }
        return pausedRemaining ?? 0
    }

    private func format(_ interval: TimeInterval) -> String {
        let total = Int(interval.rounded(.up))
        return String(format: "%02d:%02d:%02d", total / 3600, (total % 3600) / 60, total % 60)
    }

    private func start() {
        let duration = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        if let paused = pausedRemaining {
            endDate = .now.addingTimeInterval(paused)
            pausedRemaining = nil
        } else {
            guard duration > 0 else { return }
            totalDuration = duration
            endDate = .now.addingTimeInterval(duration)
        }
    }

    private func pause() {
        pausedRemaining = remainingTime(at: .now)
        endDate = nil
    }

    private func cancel() {
        endDate = nil
        pausedRemaining = nil
    }
}
