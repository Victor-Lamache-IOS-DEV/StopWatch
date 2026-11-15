import SwiftUI

struct TimerView: View {
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle().stroke(Color.secondary.opacity(0.2), lineWidth: 8)
                Text("00:00:00").font(.system(size: 48, weight: .thin, design: .monospaced)).monospacedDigit()
            }
            .frame(width: 260, height: 260)
            Spacer()
            HStack {
                Button("Cancel") {}.buttonStyle(.glass).tint(.gray)
                Spacer()
                Button("Start") {}.buttonStyle(.glassProminent).tint(.green)
            }
            .padding(.horizontal, 40).padding(.bottom, 20)
        }
        .navigationTitle("Timer")
    }
}