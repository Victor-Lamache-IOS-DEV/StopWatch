import Foundation

enum ClockFormatting {
    static let uses12Hour: Bool = {
        let format = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: .current) ?? ""
        return format.contains("a")
    }()

    static func timeParts(for date: Date, in timeZone: TimeZone) -> (time: String, suffix: String?) {
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

    static func cityName(for zoneID: String) -> String {
        (zoneID.split(separator: "/").last.map(String.init) ?? zoneID).replacingOccurrences(of: "_", with: " ")
    }

    static func detail(in timeZone: TimeZone, now: Date) -> String {
        let hours = (timeZone.secondsFromGMT(for: now) - TimeZone.current.secondsFromGMT(for: now)) / 3600
        let offset = "\(hours >= 0 ? "+" : "")\(hours) HRS"
        let day: String? = switch dayOffset(in: timeZone, now: now) {
        case 0: "Today"
        case 1: "Tomorrow"
        case -1: "Yesterday"
        default: nil
        }
        return [day, offset].compactMap { $0 }.joined(separator: ", ")
    }

    private static func dayOffset(in timeZone: TimeZone, now: Date) -> Int {
        var remote = Calendar.current
        remote.timeZone = timeZone
        let remoteDay = remote.dateComponents([.year, .month, .day], from: now)
        let localDay = Calendar.current.dateComponents([.year, .month, .day], from: now)
        let remoteDate = Calendar.current.date(from: remoteDay) ?? now
        let localDate = Calendar.current.date(from: localDay) ?? now
        return Calendar.current.dateComponents([.day], from: localDate, to: remoteDate).day ?? 0
    }
}
