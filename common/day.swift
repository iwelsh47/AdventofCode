//
//  day.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 12/01/24.
//

import Foundation

class Day {
    let day: Int
    let year: Int
    
    var data: String {
        get {
            loadData(from: String(format: "input%02d", self.day), for: self.year)
        }
    }
    
    var example1: String {
        get {
            loadData(from: String(format: "example%02d_1", self.day), for: self.year)
        }
    }
    
    var example2: String {
        get {
            loadData(from: String(format: "example%02d_2", self.day), for: self.year)
        }
    }
    
    init(day: Int, year: Int) {
        self.day = day
        self.year = year
    }
    
    func run() { print("No run function implemented") }
}

#if false

@main final class Today: Day {
    init() { super.init(day: 0, year: 0) }
    
    override func run() {
        print("Running \(year), day \(day)")
    }
    
    static func main() { Today().run() }
}

#endif
