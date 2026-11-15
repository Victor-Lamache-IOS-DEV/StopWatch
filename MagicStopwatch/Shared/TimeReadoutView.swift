import SwiftUI

struct TimeReadoutView: View {
    let time: String
    let suffix: String?
    var size: CGFloat = 40

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 3) {
            Text(time)
                .font(.system(size: size, weight: .light))
                .monospacedDigit()
            if let suffix {
                Text(suffix)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
