import SwiftUI

struct AlarmItem: Identifiable {
    let id = UUID()
    var hour: Int
    var minute: Int
    var label: String
    var repeatSummary: String
    var isOn: Bool
}

struct AlarmView: View {
    @State private var alarms: [AlarmItem] = [
        AlarmItem(hour: 7, minute: 0, label: "Alarm", repeatSummary: "Weekdays", isOn: true),
        AlarmItem(hour: 8, minute: 30, label: "Gym", repeatSummary: "Mon, Wed", isOn: false)
    ]

    var body: some View {
        List {
            ForEach($alarms) { $alarm in
                let parts = ClockFormatting.timeParts(for: date(for: alarm), in: .current)
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .firstTextBaseline, spacing: 3) {
                            Text(parts.time)
                                .font(.system(size: 48, weight: .light))
                                .monospacedDigit()
                            if let suffix = parts.suffix {
                                Text(suffix)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .foregroundStyle(alarm.isOn ? .primary : .secondary)
                        Text(alarm.label)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(alarm.repeatSummary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Toggle("", isOn: $alarm.isOn)
                        .labelsHidden()
                        .tint(.green)
                }
                .padding(.vertical, 4)
            }
            .onDelete { alarms.remove(atOffsets: $0) }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Alarm")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    alarms.append(AlarmItem(hour: 8, minute: 0, label: "Alarm", repeatSummary: "Today", isOn: false))
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func date(for alarm: AlarmItem) -> Date {
        Calendar.current.date(bySettingHour: alarm.hour, minute: alarm.minute, second: 0, of: .now) ?? .now
    }
}
