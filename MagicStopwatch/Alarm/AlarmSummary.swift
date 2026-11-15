import Foundation

enum AlarmSummary {
    static func repeatText(for alarm: Alarm, now: Date = .now) -> String {
        let days = Set(alarm.repeatDays)
        if days.isEmpty { return oneTimeText(for: alarm, now: now) }
        if days == Set(Weekday.allCases) { return "Every day" }
        if days == Weekday.weekdays { return "Weekdays" }
        if days == Weekday.weekends { return "Weekends" }
        return Weekday.allCases.filter { days.contains($0) }.map(\.shortName).joined(separator: ", ")
    }

    private static func oneTimeText(for alarm: Alarm, now: Date) -> String {
        let components = DateComponents(hour: alarm.hour, minute: alarm.minute, second: 0)
        guard let next = Calendar.current.nextDate(after: now, matching: components, matchingPolicy: .nextTime) else {
            return ""
        }
        if Calendar.current.isDateInToday(next) { return "Today" }
        if Calendar.current.isDateInTomorrow(next) { return "Tomorrow" }
        return next.formatted(.dateTime.weekday(.wide))
    }
}
