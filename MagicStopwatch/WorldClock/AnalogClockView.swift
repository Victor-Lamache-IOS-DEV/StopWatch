import SwiftUI

struct AnalogClockView: View {
    let name: String
    let timeZoneIdentifier: String

    var body: some View {
        let timeZone = TimeZone(identifier: timeZoneIdentifier) ?? .current
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let clock = TimeFormatting.clockParts(for: context.date, in: timeZone)
            ClockFaceView(date: context.date, timeZone: timeZone)
                .aspectRatio(1, contentMode: .fit)
                .padding(48)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityLabel("\(name), \(clock.time)\(clock.suffix.map { " \($0)" } ?? "")")
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
        .backgroundExtensionEffect()
    }
}
