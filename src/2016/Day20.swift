//
//  Day20.swift
//  Day20_2016
//
//  Created by Ivan Welsh on 28/01/24.
//

import Foundation

struct IPRange: Comparable {
    static func < (lhs: IPRange, rhs: IPRange) -> Bool {
        if lhs.startRange == rhs.startRange {
            return lhs.endRange < rhs.endRange
        }
        return lhs.startRange < rhs.startRange
    }
    
    var startRange: UInt64
    var endRange: UInt64
    
    init(startRange: UInt64, endRange: UInt64) {
        self.startRange = startRange
        self.endRange = endRange
    }
    
    init(from str: String) {
        (startRange, endRange) = str.components(separatedBy: "-").map{ UInt64($0)! }.splat()
    }
    
    func merge(with other: IPRange) -> IPRange? {
        if other.startRange > endRange + 1 { return nil } // can't merge
        return IPRange(startRange: startRange, endRange: max(endRange, other.endRange))
    }
}

@main final class Today: Day {
    init() { super.init(day: 20, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var ipranges = data.components(separatedBy: "\n").map{ IPRange(from: $0) }
        ipranges.sort()
        var rng = [ipranges.first!]
        for idx in 1..<ipranges.count {
            guard let merged = rng.last!.merge(with: ipranges[idx])
            else {
                rng.append(ipranges[idx])
                continue
            }
            rng[rng.count - 1] = merged
        }
        print("First allowed value is \(rng.first!.endRange + 1)")
        let numAllowedValues = (1..<rng.count)
                                    .map{rng[$0].startRange - rng[$0 - 1].endRange - 1}
                                    .sum() +
                                UInt64(UInt32.max) - rng.last!.endRange
        print("Total allowed values is \(numAllowedValues)")
    }
    
    static func main() { Today().run() }
}
