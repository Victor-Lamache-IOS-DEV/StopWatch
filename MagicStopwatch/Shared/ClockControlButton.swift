import SwiftUI

struct ClockControlButton: View {
    let title: LocalizedStringKey
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body)
                .frame(width: 80, height: 80)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .tint(tint)
    }
}
