import SwiftUI

struct DurationPickerView: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int

    var body: some View {
        HStack(spacing: 0) {
            column($hours, range: 0..<24, unit: "hours")
            column($minutes, range: 0..<60, unit: "min")
            column($seconds, range: 0..<60, unit: "sec")
        }
        .frame(height: 260)
    }

    private func column(_ value: Binding<Int>, range: Range<Int>, unit: LocalizedStringKey) -> some View {
        HStack(spacing: 6) {
            Picker(unit, selection: value) {
                ForEach(range, id: \.self) { number in
                    Text("\(number)").tag(number)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            Text(unit)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
