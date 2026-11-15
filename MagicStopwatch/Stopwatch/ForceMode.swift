import Foundation

enum ForceMode: String, CaseIterable, Identifiable {
    case finalOnly
    case sequence

    var id: String { rawValue }

    var title: String {
        switch self {
        case .finalOnly: "Final Only"
        case .sequence: "Sequence"
        }
    }
}
