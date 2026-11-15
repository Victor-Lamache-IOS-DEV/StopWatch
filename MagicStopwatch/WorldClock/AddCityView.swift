import SwiftUI
import SwiftData

struct AddCityView: View {
    let existingIdentifiers: Set<String>
    let nextOrder: Int

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    private var results: [String] {
        guard !query.isEmpty else { return [] }
        return TimeZone.knownTimeZoneIdentifiers
            .filter { $0.localizedCaseInsensitiveContains(query) }
            .prefix(60)
            .map { $0 }
    }

    var body: some View {
        NavigationStack {
            List(results, id: \.self) { identifier in
                Button {
                    modelContext.insert(City(timeZoneIdentifier: identifier, order: nextOrder))
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(TimeFormatting.cityName(for: identifier))
                        Text(identifier)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .disabled(existingIdentifiers.contains(identifier))
            }
            .listStyle(.insetGrouped)
            .searchable(text: $query, prompt: "Search for a city or airport")
            .navigationTitle("Add City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
            }
        }
    }
}
