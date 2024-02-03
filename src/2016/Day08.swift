//
//  Day08.swift
//  Day08_2016
//
//  Created by Ivan Welsh on 20/01/24.
//

import Foundation

struct LCDisplay {
    var panel: Array2D<Bool>
    
    init(numRows: Int, numCols: Int) {
        panel = Array2D(columns: numCols, rows: numRows, fill: false)
    }
    
    func printPanel() {
        for row in 0..<panel.rows {
            var segments = [String]()
            for col in 0..<panel.columns {
                if panel[col, row]! { segments.append("#") }
                else { segments.append(" ") }
            }
            print(segments.joined(separator: ""))
        }
    }
    
    mutating func run(instructions: String) {
        for instruction in instructions.components(separatedBy: "\n") {
//            print(instruction)
            let bits = instruction.components(separatedBy: " ")
            if bits[0] == "rect" {
                let (width, height) = bits[1].components(separatedBy: "x").map({Int($0)!}).splat()
                rect(width: width, height: height)
            } else {
                let (_, rc) = bits[2].components(separatedBy: "=").map({Int($0) ?? 0}).splat()
                let amount = Int(bits[4])!
                if bits[1] == "row" { rotate(row: rc, by: amount) }
                else { rotate(col: rc, by: amount) }
            }
//            printPanel()
        }
    }
    
    mutating func rotate(row: Int, by amount: Int) {
        var rowVals = [Bool]()
        for col in 0..<panel.columns { rowVals.append(panel[col, row]!) }
        var index = amount
        for val in rowVals {
            panel[index, row] = val
            index += 1
            if index == panel.columns { index = 0 }
        }
    }
    
    mutating func rotate(col: Int, by amount: Int) {
        var colVals = [Bool]()
        for row in 0..<panel.rows { colVals.append(panel[col, row]!) }
        var index = amount
        for val in colVals {
            panel[col, index] = val
            index += 1
            if index == panel.rows { index = 0 }
        }
    }
    
    mutating func rect(width: Int, height: Int) {
        for col in 0..<width {
            for row in 0..<height {
                panel[col, row] = true
            }
        }
    }
}

@main final class Today: Day {
    init() { super.init(day: 8, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var lcd = LCDisplay(numRows: 6, numCols: 50)
        lcd.run(instructions: data)
        let litPixels = lcd.panel.data.filter({ $0! }).count
        print("There are \(litPixels) lit pixels")
        lcd.printPanel()
    }
    
    static func main() { Today().run() }
}
