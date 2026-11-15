import Foundation

enum TimeFormatting {
    static let uses12Hour: Bool = {
        (DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: .current) ?? "").contains("a")
    }()

    static func clockParts(for date: Date, in timeZone: TimeZone) -> (time: String, suffix: String?) {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = timeZone
        formatter.dateFormat = uses12Hour ? "h:mm" : "HH:mm"
        let time = formatter.string(from: date)
        guard uses12Hour else { return (time, nil) }

        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let isAM = calendar.component(.hour, from: date) < 12
        return (time, isAM ? formatter.amSymbol : formatter.pmSymbol)
    }

    static func cityName(for identifier: String) -> String {
        let last = identifier.split(separator: "/").last.map(String.init) ?? identifier
        return last.replacingOccurrences(of: "_", with: " ")
    }

    static func zoneDetail(for timeZone: TimeZone, now: Date) -> String {
        let hours = (timeZone.secondsFromGMT(for: now) - TimeZone.current.secondsFromGMT(for: now)) / 3600
        let offset = "\(hours >= 0 ? "+" : "")\(hours) HRS"

        var remoteCalendar = Calendar.current
        remoteCalendar.timeZone = timeZone
        let remoteDate = Calendar.current.date(from: remoteCalendar.dateComponents([.year, .month, .day], from: now)) ?? now
        let localDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: now)) ?? now
        let days = Calendar.current.dateComponents([.day], from: localDate, to: remoteDate).day ?? 0

        let relative = RelativeDateTimeFormatter()
        relative.dateTimeStyle = .named
        let dayLabel: String? = (-1...1).contains(days)
            ? relative.localizedString(from: DateComponents(day: days)).capitalizedFirstLetter
            : nil

        return [dayLabel, offset].compactMap { $0 }.joined(separator: ", ")
    }

    static func stopwatch(_ interval: TimeInterval) -> String {
        let total = max(0, Int((interval * 100).rounded(.down)))
        return String(format: "%02d:%02d.%02d", total / 6000, (total / 100) % 60, total % 100)
    }

    static func countdown(_ interval: TimeInterval) -> String {
        let total = max(0, Int(interval.rounded(.up)))
        return String(format: "%02d:%02d:%02d", total / 3600, (total % 3600) / 60, total % 60)
    }
}

private extension String {
    var capitalizedFirstLetter: String {
        prefix(1).uppercased() + dropFirst()
    }
}
