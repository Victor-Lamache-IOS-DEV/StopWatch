import SwiftUI

struct StopwatchView: View {
    @State private var engine = StopwatchEngine()
    @State private var showSettings = false
    @State private var tapCount = 0
    @State private var tapTimer: Timer?

    var body: some View {
        VStack(spacing: 0) {
            TimelineView(.animation) { _ in
                Text(formatTime(engine.isRunning ? engine.currentElapsed() : engine.elapsedTime))
                    .font(.system(size: 76, weight: .thin))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .contentShape(Rectangle())
                    .onTapGesture { handleTripleTap() }
            }
            .padding(.top, 60)
            .padding(.horizontal, 20)

            GlassEffectContainer {
                HStack {
                    Button {
                        if engine.isRunning { engine.lap() } else { engine.reset() }
                    } label: {
                        Text(engine.isRunning ? "Lap" : "Reset")
                            .font(.body)
                            .frame(width: 80, height: 80)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .tint(.gray)

                    Spacer()

                    Button {
                        if engine.isRunning { engine.stop() } else { engine.start() }
                    } label: {
                        Text(engine.isRunning ? "Stop" : "Start")
                            .font(.body)
                            .frame(width: 80, height: 80)
                    }
                    .buttonStyle(.glassProminent)
                    .buttonBorderShape(.circle)
                    .tint(engine.isRunning ? .red : .green)
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 24)
            .sensoryFeedback(.impact, trigger: engine.laps.count)

            List {
                ForEach(engine.laps) { lap in
                    LapRow(lap: lap, engine: engine)
                }
            }
            .listStyle(.plain)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showSettings) {
            SettingsView(engine: engine)
        }
    }

    private func handleTripleTap() {
        tapCount += 1
        tapTimer?.invalidate()
        tapTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
            if tapCount >= 3 {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                showSettings = true
            }
            tapCount = 0
        }
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        let hundredths = Int(floor((interval.truncatingRemainder(dividingBy: 1)) * 100 + 0.05))
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths % 100)
    }
}

struct LapRow: View {
    let lap: Lap
    let engine: StopwatchEngine

    var lapColor: Color {
        if lap.id == engine.shortestLapID { return .green }
        if lap.id == engine.longestLapID { return .red }
        return .primary
    }

    var body: some View {
        HStack {
            Text("Lap \(lap.lapNumber)")
                .frame(width: 90, alignment: .leading)
            Spacer()
            Text(formatTime(lap.lapTime))
                .monospacedDigit()
            Spacer()
            Text(formatTime(lap.totalTime))
                .monospacedDigit()
                .frame(width: 110, alignment: .trailing)
        }
        .font(.body)
        .foregroundStyle(lapColor)
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        let hundredths = Int(floor((interval.truncatingRemainder(dividingBy: 1)) * 100 + 0.05))
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths % 100)
    }
}

struct SettingsView: View {
    @Bindable var engine: StopwatchEngine
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Arm Magic", isOn: $engine.isArmed)
                } header: { Text("Status") } footer: { Text("When armed, the force mechanism is active. Long-press between Reset/Start buttons to toggle this silently.") }

                Section("Force Mode") {
                    Picker("Mode", selection: $engine.forceMode) {
                        ForEach(StopwatchEngine.ForceMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if engine.forceMode == .sequence {
                    Section {
                        TextField("Enter sequence (e.g. 2538789)", text: $engine.sequenceInput)
                            .keyboardType(.numberPad)

                        if !engine.forcedLapDigits.isEmpty || !engine.forcedStopDigits.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(0..<engine.forcedLapDigits.count, id: \.self) { index in
                                    Text("Lap \(index + 1): .\(engine.forcedLapDigits[index])")
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                                Text("Final Stop: .\(engine.forcedStopDigits)")
                                    .font(.caption).fontWeight(.bold).foregroundStyle(.orange)
                            }
                            .padding(.top, 4)
                        }
                    } header: {
                        Text("Sequence Entry")
                    } footer: {
                        Text("Enter a string of numbers. It will be split into pairs for laps, and the last pair for the final stop.")
                    }
                } else {
                    Section("Final Stop Force") {
                        TextField("2 digits (e.g. 42)", text: $engine.forcedStopDigits)
                            .keyboardType(.numberPad)
                            .onChange(of: engine.forcedStopDigits) { _, newValue in
                                engine.forcedStopDigits = String(newValue.prefix(2)).filter { $0.isNumber }
                            }
                    }
                }
            }
            .navigationTitle("Magic Settings")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}
