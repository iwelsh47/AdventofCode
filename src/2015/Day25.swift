//
//  Day25.swift
//  Day25_2015
//
//  Created by Ivan Welsh on 17/01/24.
//

import Foundation

@main final class Today: Day {
    init() { super.init(day: 25, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        var row = 1
        var col = 1
        let targetRow = 2978
        let targetCol = 3083
        var previous = 20151125
        while row != targetRow || col != targetCol {
            previous = (previous * 252533).quotientAndRemainder(dividingBy: 33554393).remainder
            if row == 1 {
                row = col + 1
                col = 1
            } else {
                row -= 1
                col += 1
            }
        }
        print("Requested code is \(previous)")
    }
    
    static func main() { Today().run() }
}
