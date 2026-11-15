import SwiftUI

struct AlarmRowView: View {
    let alarm: Alarm

    var body: some View {
        let clock = TimeFormatting.clockParts(for: alarm.time, in: .current)
        VStack(alignment: .leading, spacing: 2) {
            TimeReadoutView(time: clock.time, suffix: clock.suffix, size: 48)
                .foregroundStyle(alarm.isEnabled ? .primary : .secondary)
            Text(alarm.label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(AlarmSummary.repeatText(for: alarm))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
