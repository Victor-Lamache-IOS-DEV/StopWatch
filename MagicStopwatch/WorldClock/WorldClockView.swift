import SwiftUI
import SwiftData

struct WorldClockView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \City.order) private var cities: [City]
    @State private var showAddCity = false

    private var localIdentifier: String { TimeZone.current.identifier }

    var body: some View {
        List {
            Section {
                NavigationLink {
                    AnalogClockView(name: TimeFormatting.cityName(for: localIdentifier), timeZoneIdentifier: localIdentifier)
                } label: {
                    WorldClockRowView(timeZoneIdentifier: localIdentifier)
                }
            }

            Section {
                ForEach(cities) { city in
                    NavigationLink {
                        AnalogClockView(name: city.name, timeZoneIdentifier: city.timeZoneIdentifier)
                    } label: {
                        WorldClockRowView(timeZoneIdentifier: city.timeZoneIdentifier)
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("World Clock")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add City", systemImage: "plus") {
                    showAddCity = true
                }
            }
        }
        .sheet(isPresented: $showAddCity) {
            AddCityView(existingIdentifiers: Set(cities.map(\.timeZoneIdentifier)), nextOrder: cities.count)
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(cities[index])
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        var reordered = cities
        reordered.move(fromOffsets: source, toOffset: destination)
        for (index, city) in reordered.enumerated() {
            city.order = index
        }
    }
}
