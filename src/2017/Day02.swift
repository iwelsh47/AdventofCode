//
//  Day02.swift
//  Day02_2017
//
//  Created by Ivan Welsh on 4/02/24.
//

import Foundation

func spreadsheetChecksum(of str: String) -> Int {
    var checksum = 0
    for row in str.components(separatedBy: "\n") {
        let values = row.components(separatedBy: .whitespaces).map{ Int($0)! }
        checksum += values.max()! - values.min()!
    }
    return checksum
}

func alternativeChecksum(of str: String) -> Int {
    var checksum = 0
    for row in str.components(separatedBy: "\n") {
        let values = row.components(separatedBy: .whitespaces).map{ Int($0)! }
        for idx1 in 0..<values.count {
            var broken = false
            for idx2 in 0..<values.count {
                if idx1 == idx2 { continue }
                if values[idx1].isMultiple(of: values[idx2]) {
                    checksum += values[idx1] / values[idx2]
                    broken = true
                    break
                }
            }
            if broken { break }
        }
    }
    return checksum
}

@main final class Today: Day {
    init() { super.init(day: 2, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        print("Spreadsheet checksum is \(spreadsheetChecksum(of: data))")
        print("Alternative spreadsheet checksum is \(alternativeChecksum(of: data))")
    }
    
    static func main() { Today().run() }
}
