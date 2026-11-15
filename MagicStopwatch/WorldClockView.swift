import SwiftUI

struct WorldClockView: View {
    var body: some View {
        List {
            ClockRow(city: "Cupertino", offset: "Today, -9 HRS", time: "04:11")
            ClockRow(city: "Paris", offset: "Today, +0 HRS", time: "13:11")
            ClockRow(city: "Tokyo", offset: "Today, +8 HRS", time: "21:11")
        }
        .listStyle(.insetGrouped)
        .navigationTitle("World Clock")
    }
}

struct ClockRow: View {
    let city: String
    let offset: String
    let time: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(city).font(.title3)
                Text(offset).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(time).font(.system(size: 34, weight: .light, design: .monospaced)).monospacedDigit()
        }
        .padding(.vertical, 4)
    }
}