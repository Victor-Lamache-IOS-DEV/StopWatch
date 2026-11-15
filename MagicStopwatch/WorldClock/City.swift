import Foundation
import SwiftData

@Model
final class City {
    var id: UUID
    var name: String
    var timeZoneIdentifier: String
    var order: Int

    init(timeZoneIdentifier: String, order: Int) {
        self.id = UUID()
        self.name = TimeFormatting.cityName(for: timeZoneIdentifier)
        self.timeZoneIdentifier = timeZoneIdentifier
        self.order = order
    }
}
