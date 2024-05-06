//
//  Day01.swift
//  Day01_2017
//
//  Created by Ivan Welsh on 4/02/24.
//

import Foundation

func sumAdjacentValues(in str: String, offset: Int = 1) -> Int {
    var idx1 = str.startIndex
    var idx2 = str.index(idx1, offsetBy: offset)
    var adjacentCount = 0
    while idx1 != str.endIndex {
        if str[idx1] == str[idx2] {
            adjacentCount += Int(String(str[idx1]))!
        }
        idx1 = str.index(after: idx1)
        idx2 = str.index(after: idx2)
        if idx2 == str.endIndex { idx2 = str.startIndex }
    }
    return adjacentCount
}

@main final class Today: Day {
    init() { super.init(day: 1, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        print("Captcha solution is \(sumAdjacentValues(in: data))")
        print("Second captcha solution is \(sumAdjacentValues(in: data, offset: data.count / 2))")
    }
    
    static func main() { Today().run() }
}
