import SwiftUI

struct WorldClockView: View {
    @State private var zoneIDs: [String] = ["America/Los_Angeles", "Europe/Paris", "Asia/Tokyo"]
    @State private var showAddCity = false

    var body: some View {
        List {
            NavigationLink {
                AnalogClockView(zoneID: TimeZone.current.identifier)
            } label: {
                WorldClockRow(zoneID: TimeZone.current.identifier)
            }
            .deleteDisabled(true)
            .moveDisabled(true)

            ForEach(zoneIDs, id: \.self) { id in
                NavigationLink {
                    AnalogClockView(zoneID: id)
                } label: {
                    WorldClockRow(zoneID: id)
                }
            }
            .onDelete { zoneIDs.remove(atOffsets: $0) }
            .onMove { zoneIDs.move(fromOffsets: $0, toOffset: $1) }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("World Clock")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddCity = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddCity) {
            CityPickerSheet { id in
                if !zoneIDs.contains(id) { zoneIDs.append(id) }
            }
        }
    }
}

struct WorldClockRow: View {
    let zoneID: String

    var body: some View {
        let timeZone = TimeZone(identifier: zoneID) ?? .current
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let parts = ClockFormatting.timeParts(for: context.date, in: timeZone)
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(ClockFormatting.cityName(for: zoneID))
                        .font(.body)
                    Text(ClockFormatting.detail(in: timeZone, now: context.date))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text(parts.time)
                        .font(.system(size: 40, weight: .light))
                        .monospacedDigit()
                    if let suffix = parts.suffix {
                        Text(suffix)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

struct CityPickerSheet: View {
    let onSelect: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    private var results: [String] {
        guard !query.isEmpty else { return [] }
        return TimeZone.knownTimeZoneIdentifiers
            .filter { $0.localizedCaseInsensitiveContains(query) }
            .prefix(50)
            .map { $0 }
    }

    var body: some View {
        NavigationStack {
            List(results, id: \.self) { id in
                Button {
                    onSelect(id)
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ClockFormatting.cityName(for: id))
                        Text(id)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $query, prompt: "Search for a city or airport")
            .navigationTitle("Add City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
            }
        }
    }
}

struct AnalogClockView: View {
    let zoneID: String

    var body: some View {
        let timeZone = TimeZone(identifier: zoneID) ?? .current
        let name = ClockFormatting.cityName(for: zoneID)
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let parts = ClockFormatting.timeParts(for: context.date, in: timeZone)
            ClockFace(date: context.date, timeZone: timeZone)
                .aspectRatio(1, contentMode: .fit)
                .padding(40)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityLabel("\(name), \(parts.time)\(parts.suffix.map { " \($0)" } ?? "")")
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
        .backgroundExtensionEffect()
    }
}

struct ClockFace: View {
    let date: Date
    let timeZone: TimeZone

    var body: some View {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let parts = calendar.dateComponents([.hour, .minute, .second], from: date)
        let hour = Double((parts.hour ?? 0) % 12)
        let minute = Double(parts.minute ?? 0)
        let second = Double(parts.second ?? 0)

        return Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2

            context.fill(
                Path(ellipseIn: CGRect(origin: .zero, size: size)),
                with: .color(Color(uiColor: .secondarySystemBackground))
            )

            for index in 0..<12 {
                let angle = Double(index) / 12 * 2 * .pi
                let isMajor = index % 3 == 0
                var tick = Path()
                tick.move(to: point(center, angle, radius * 0.94))
                tick.addLine(to: point(center, angle, radius * (isMajor ? 0.78 : 0.86)))
                context.stroke(
                    tick,
                    with: .color(.primary),
                    style: StrokeStyle(lineWidth: isMajor ? 5 : 2, lineCap: .round)
                )
            }

            let hourAngle = (hour + minute / 60) / 12 * 2 * .pi
            let minuteAngle = (minute + second / 60) / 60 * 2 * .pi
            let secondAngle = second / 60 * 2 * .pi

            var hourHand = Path()
            hourHand.move(to: center)
            hourHand.addLine(to: point(center, hourAngle, radius * 0.5))
            context.stroke(hourHand, with: .color(.primary), style: StrokeStyle(lineWidth: 7, lineCap: .round))

            var minuteHand = Path()
            minuteHand.move(to: center)
            minuteHand.addLine(to: point(center, minuteAngle, radius * 0.78))
            context.stroke(minuteHand, with: .color(.primary), style: StrokeStyle(lineWidth: 5, lineCap: .round))

            var secondHand = Path()
            secondHand.move(to: point(center, secondAngle + .pi, radius * 0.2))
            secondHand.addLine(to: point(center, secondAngle, radius * 0.86))
            context.stroke(secondHand, with: .color(.red), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))

            context.fill(
                Path(ellipseIn: CGRect(x: center.x - 6, y: center.y - 6, width: 12, height: 12)),
                with: .color(.red)
            )
        }
    }

    private func point(_ center: CGPoint, _ angle: Double, _ length: Double) -> CGPoint {
        CGPoint(x: center.x + sin(angle) * length, y: center.y - cos(angle) * length)
    }
}
