import SwiftUI

struct ClockFaceView: View {
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
