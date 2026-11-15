import SwiftUI
import SwiftData

struct AlarmEditorView: View {
    @Bindable var alarm: Alarm
    let isNew: Bool

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var time: Date

    init(alarm: Alarm, isNew: Bool) {
        self.alarm = alarm
        self.isNew = isNew
        _time = State(initialValue: alarm.time)
    }

    var body: some View {
        Form {
            Section {
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }

            Section {
                ForEach(Weekday.allCases) { day in
                    Button {
                        toggle(day)
                    } label: {
                        LabeledContent(day.fullName) {
                            if alarm.repeatDays.contains(day) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.orange)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            } header: {
                Text("Repeat")
            }

            Section {
                Button("Every Day") { alarm.repeatDays = Weekday.allCases }
                Button("Weekdays") { alarm.repeatDays = Weekday.allCases.filter { Weekday.weekdays.contains($0) } }
                Button("Weekends") { alarm.repeatDays = Weekday.allCases.filter { Weekday.weekends.contains($0) } }
                Button("Never") { alarm.repeatDays = [] }
            }

            Section {
                TextField("Label", text: $alarm.label)
            }

            Section {
                Picker("Sound", selection: $alarm.soundName) {
                    Text("Default").tag("Default")
                }
            }

            Section {
                Toggle("Snooze", isOn: $alarm.snoozeEnabled)
            } footer: {
                Text("Snooze every \(alarm.snoozeMinutes) minutes.")
            }

            if !isNew {
                Section {
                    Button("Delete Alarm", role: .destructive) {
                        modelContext.delete(alarm)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle(isNew ? "Add Alarm" : "Edit Alarm")
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled(isNew)
        .onChange(of: time) { _, newValue in
            let parts = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            alarm.hour = parts.hour ?? alarm.hour
            alarm.minute = parts.minute ?? alarm.minute
        }
        .toolbar {
            if isNew {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        modelContext.delete(alarm)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { dismiss() }
                        .buttonStyle(.glassProminent)
                }
            }
        }
    }

    private func toggle(_ day: Weekday) {
        if let index = alarm.repeatDays.firstIndex(of: day) {
            alarm.repeatDays.remove(at: index)
        } else {
            alarm.repeatDays.append(day)
        }
    }
}
