import SwiftUI

struct WorldClockRowView: View {
    let timeZoneIdentifier: String

    var body: some View {
        let timeZone = TimeZone(identifier: timeZoneIdentifier) ?? .current
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let clock = TimeFormatting.clockParts(for: context.date, in: timeZone)
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(TimeFormatting.cityName(for: timeZoneIdentifier))
                        .font(.body)
                    Text(TimeFormatting.zoneDetail(for: timeZone, now: context.date))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                TimeReadoutView(time: clock.time, suffix: clock.suffix)
            }
            .padding(.vertical, 4)
            .accessibilityElement(children: .combine)
        }
    }
}
