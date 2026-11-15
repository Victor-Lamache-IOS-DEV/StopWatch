import SwiftUI

struct LapRowView: View {
    let lap: Lap
    let tint: Color

    var body: some View {
        HStack {
            Text("Lap \(lap.number)")
            Spacer()
            Text(TimeFormatting.stopwatch(lap.lapTime))
                .monospacedDigit()
            Spacer()
            Text(TimeFormatting.stopwatch(lap.totalTime))
                .monospacedDigit()
                .frame(width: 120, alignment: .trailing)
        }
        .foregroundStyle(tint)
    }
}
