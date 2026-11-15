import SwiftUI

struct AlarmView: View {
    var body: some View {
        List {
            AlarmRow(time: "07:00", label: "Work", isOn: false)
            AlarmRow(time: "08:30", label: "Gym", isOn: false)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Alarm")
    }
}

struct AlarmRow: View {
    let time: String
    let label: String
    @State var isOn: Bool
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(time).font(.system(size: 34, weight: .light, design: .monospaced)).monospacedDigit().foregroundStyle(isOn ? .primary : .secondary)
                Text(label).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: $isOn).tint(.green)
        }
    }
}