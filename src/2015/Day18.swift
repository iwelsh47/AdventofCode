//
//  Day18.swift
//  Day18_2015
//
//  Created by Ivan Welsh on 14/01/24.
//

import Foundation

extension Array2D<Bool> {
    init(from serialised: String) {
        let rows = serialised.components(separatedBy: "\n")
        self.init(columns: rows[0].count, rows: rows.count, fill: false)
        for (i, row) in rows.enumerated() {
            for (j, column) in row.enumerated() {
                if column == "#" { self[i, j] = true }
            }
        }
    }
    
    func neighbouringOnCount(row: Int, column: Int) -> Int {
        let neighbours = [(row + 1, column - 1),
                          (row + 1, column),
                          (row + 1, column + 1),
                          (row, column - 1),
                          (row, column + 1),
                          (row - 1, column - 1),
                          (row - 1, column),
                          (row - 1, column + 1)].filter({ $0.0 >= 0 && $0.1 >= 0 && $0.0 < rows && $0.1 < columns })
        var onCount = 0
        for (row, column) in neighbours {
            if self[row, column]! { onCount += 1 }
        }
        return onCount
    }
    
    func nextStep() -> Array2D<Bool> {
        var newConfiguration = Array2D(columns: columns, rows: rows, fill: false)
        for row in 0..<rows {
            for column in 0..<columns {
                let nbrsOn = neighbouringOnCount(row: row, column: column)
                if self[row, column]! {
                    if nbrsOn == 2 || nbrsOn == 3 { newConfiguration[row,column] = true }
                } else {
                    if nbrsOn == 3 { newConfiguration[row, column] = true }
                }
            }
        }
        return newConfiguration
    }
    
    func nextBrokenStep() -> Array2D<Bool> {
        var newConfiguration = Array2D(columns: columns, rows: rows, fill: false)
        for row in 0..<rows {
            for column in 0..<columns {
                if (row == 0 && column == 0) || (row == 0 && column == columns - 1)
                    || (row == rows - 1 && column == 0) || (row == rows - 1 && column == columns - 1) {
                    newConfiguration[row, column] = true
                } else {
                    let nbrsOn = neighbouringOnCount(row: row, column: column)
                    if self[row, column]! {
                        if nbrsOn == 2 || nbrsOn == 3 { newConfiguration[row,column] = true }
                    } else {
                        if nbrsOn == 3 { newConfiguration[row, column] = true }
                    }
                }
            }
        }
        return newConfiguration
    }
}

@main final class Today: Day {
    init() { super.init(day: 18, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var lightPanels = Array2D(from: data)
        for _ in 1...100 { lightPanels = lightPanels.nextStep() }
        print("After 100 steps there are \(lightPanels.data.filter({ $0! }).count) panels lit.")
        var brokenPanels = Array2D(from: data)
        brokenPanels[0, 0] = true
        brokenPanels[0, 99] = true
        brokenPanels[99, 0] = true
        brokenPanels[99, 99] = true
        for _ in 1...100 { brokenPanels = brokenPanels.nextBrokenStep() }
        print("After 100 steps with broken lights there are \(brokenPanels.data.filter({ $0! }).count) panels lit.")
        
    }
    
    static func main() { Today().run() }
}
