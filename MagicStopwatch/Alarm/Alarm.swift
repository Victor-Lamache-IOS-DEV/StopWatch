import Foundation
import SwiftData

@Model
final class Alarm {
    var id: UUID
    var hour: Int
    var minute: Int
    var label: String
    var isEnabled: Bool
    var repeatDays: [Weekday]
    var soundName: String
    var snoozeEnabled: Bool
    var snoozeMinutes: Int
    var alarmKitID: UUID?

    init(hour: Int = 8, minute: Int = 0, label: String = "Alarm") {
        self.id = UUID()
        self.hour = hour
        self.minute = minute
        self.label = label
        self.isEnabled = true
        self.repeatDays = []
        self.soundName = "Default"
        self.snoozeEnabled = true
        self.snoozeMinutes = 9
        self.alarmKitID = nil
    }

    var time: Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: .now) ?? .now
    }
}
