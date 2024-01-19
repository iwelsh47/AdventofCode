//
//  Day06.swift
//  Day06_2016
//
//  Created by Ivan Welsh on 19/01/24.
//

import Foundation

@main final class Today: Day {
    init() { super.init(day: 6, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var charCounts = Array(repeating: [Character:Int](), count: 8)
        for output in data.components(separatedBy: "\n") {
            for (n, char) in output.enumerated() {
                charCounts[n][char, default: 0] += 1
            }
        }
        let errorCorrected = charCounts.map({ String($0.max(by: { $0.value < $1.value })!.key) }).joined(separator: "")
        print("Error corrected output is \(errorCorrected).")
        let original = charCounts.map({ String($0.max(by: { $0.value > $1.value })!.key) }).joined(separator: "")
        print("Original corrected output is \(original)")
        
    }
    
    static func main() { Today().run() }
}
