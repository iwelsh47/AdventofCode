//
//  Day18.swift
//  Day18_2016
//
//  Created by Ivan Welsh on 27/01/24.
//

import Foundation

func toExtended(from str: String) -> [Bool] {
    var extended = [true] // true if safe, false if not
    extended.reserveCapacity(str.count + 2)
    for char in str {
        if char == "." { extended.append(true) }
        else { extended.append(false )}
    }
    extended.append(true)
    return extended
}

func row(after previous: String) -> String {
    let extended = toExtended(from: previous)
    var nextRow = [String]()
    nextRow.reserveCapacity(previous.count)
    for i in 1...previous.count {
        let left = extended[i - 1]
        let center = extended[i]
        let right = extended[i + 1]
        if (!left && !center && right) ||
            (left && !center && !right) ||
            (!left && center && right) ||
            (left && center && !right) { nextRow.append("^") }
        else { nextRow.append(".") }
    }
    return nextRow.joined()
}

@main final class Today: Day {
    init() { super.init(day: 18, year: 2016) }
    let input = ".^..^....^....^^.^^.^.^^.^.....^.^..^...^^^^^^.^^^^.^.^^^^^^^.^^^^^..^.^^^.^^..^.^^.^....^.^...^^.^."
    override func run() {
        print("Running \(year), day \(day)")
        var previous = input
        var safeCount = previous.countInstances(of: ".")
        var numRows = 1
        while numRows < 400000 {
            if numRows == 40 {
                print("After 40 rows there are \(safeCount) safe tiles")
            }
            let nextRow = row(after: previous)
            numRows += 1
            safeCount += nextRow.countInstances(of: ".")
            previous = nextRow
        }
        print("After 400,000 rows there are \(safeCount) safe tiles")
        
    }
    
    static func main() { Today().run() }
}
