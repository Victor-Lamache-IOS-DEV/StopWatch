import SwiftUI
import SwiftData

@main
struct MagicStopwatchApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: [City.self, Alarm.self])
    }
}
