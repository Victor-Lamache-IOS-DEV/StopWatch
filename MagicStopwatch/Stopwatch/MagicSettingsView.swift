import SwiftUI

struct MagicSettingsView: View {
    @Bindable var engine: StopwatchEngine
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Armed", isOn: $engine.force.isArmed)
                } footer: {
                    Text("Long-press the gap between the Reset and Start buttons to arm or disarm.")
                }

                Section {
                    Picker("Mode", selection: $engine.force.mode) {
                        ForEach(ForceMode.allCases) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                if engine.force.mode == .sequence {
                    Section {
                        TextField("e.g. 2538789", text: $engine.force.sequenceInput)
                            .keyboardType(.numberPad)
                    } header: {
                        Text("Sequence")
                    } footer: {
                        Text("Pairs of digits. Every pair but the last is a lap; the last pair is the final stop.")
                    }
                } else {
                    Section {
                        TextField("2 digits", text: $engine.force.finalDigitsInput)
                            .keyboardType(.numberPad)
                            .onChange(of: engine.force.finalDigitsInput) { _, value in
                                engine.force.finalDigitsInput = String(value.filter { $0.isNumber }.prefix(2))
                            }
                    } header: {
                        Text("Final Stop")
                    }
                }

                Section("Preview") {
                    ForEach(Array(engine.force.lapDigits.enumerated()), id: \.offset) { index, digits in
                        Text("Lap \(index + 1): .\(digits)")
                    }
                    LabeledContent("Final stop", value: engine.force.finalDigits.map { ".\($0)" } ?? "None")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
