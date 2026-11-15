import Foundation

struct MagicForce {
    var isArmed = false
    var mode: ForceMode = .finalOnly
    var finalDigitsInput = ""
    var sequenceInput = ""
    private var nextLapIndex = 0

    var pairs: [String] {
        let source = mode == .sequence ? sequenceInput : String(finalDigitsInput.prefix(2))
        let digits = source.filter { $0.isNumber }
        guard !digits.isEmpty else { return [] }
        let padded = digits.count.isMultiple(of: 2) ? digits : "0" + digits
        return stride(from: 0, to: padded.count, by: 2).map { offset in
            let start = padded.index(padded.startIndex, offsetBy: offset)
            return String(padded[start..<padded.index(start, offsetBy: 2)])
        }
    }

    var finalDigits: String? { pairs.last }

    var lapDigits: [String] {
        mode == .sequence ? Array(pairs.dropLast()) : []
    }

    mutating func nextLapDigits() -> String? {
        let digits = lapDigits
        guard nextLapIndex < digits.count else { return nil }
        defer { nextLapIndex += 1 }
        return digits[nextLapIndex]
    }

    mutating func resetLapSequence() {
        nextLapIndex = 0
    }

    static func apply(_ digits: String, to time: TimeInterval) -> TimeInterval {
        guard let value = Double(digits) else { return time }
        return floor(time) + value / 100 + 0.001
    }
}
