import SwiftUI
import SwiftData

struct AlarmView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Alarm.hour), SortDescriptor(\Alarm.minute)]) private var alarms: [Alarm]
    @State private var draft: Alarm?

    var body: some View {
        List {
            ForEach(alarms) { alarm in
                HStack {
                    NavigationLink {
                        AlarmEditorView(alarm: alarm, isNew: false)
                    } label: {
                        AlarmRowView(alarm: alarm)
                    }
                    Toggle("Alarm enabled", isOn: Bindable(alarm).isEnabled)
                        .labelsHidden()
                        .tint(.green)
                }
            }
            .onDelete(perform: delete)
        }
        .listStyle(.insetGrouped)
        .overlay {
            if alarms.isEmpty {
                ContentUnavailableView("No Alarms", systemImage: "alarm")
            }
        }
        .navigationTitle("Alarm")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Alarm", systemImage: "plus", action: addAlarm)
            }
        }
        .sheet(item: $draft) { alarm in
            NavigationStack {
                AlarmEditorView(alarm: alarm, isNew: true)
            }
        }
    }

    private func addAlarm() {
        let alarm = Alarm()
        modelContext.insert(alarm)
        draft = alarm
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(alarms[index])
        }
    }
}
