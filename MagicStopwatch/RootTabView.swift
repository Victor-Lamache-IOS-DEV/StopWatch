import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            Tab("World Clock", systemImage: "globe") {
                NavigationStack { WorldClockView() }
            }
            Tab("Alarm", systemImage: "alarm") {
                NavigationStack { AlarmView() }
            }
            Tab("Stopwatch", systemImage: "stopwatch") {
                NavigationStack { StopwatchView() }
            }
            Tab("Timer", systemImage: "timer") {
                NavigationStack { TimerView() }
            }
        }
        .tint(.orange)
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}