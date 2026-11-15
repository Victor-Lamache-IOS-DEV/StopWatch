import Foundation

enum Weekday: Int, Codable, CaseIterable, Identifiable, Sendable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    var id: Int { rawValue }

    var shortName: String { Calendar.current.shortWeekdaySymbols[rawValue - 1] }
    var fullName: String { Calendar.current.weekdaySymbols[rawValue - 1] }

    static let weekdays: Set<Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday]
    static let weekends: Set<Weekday> = [.saturday, .sunday]
}
