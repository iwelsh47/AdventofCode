//
//  Day15.swift
//  Day15_2017
//
//  Created by Ivan Welsh on 05/05/2024.
//

import Foundation

struct Generator {
    var value: UInt32
    let delta: UInt32
    let multi: UInt32
    
    mutating func next() -> UInt32 {
        while true {
            value = UInt32((UInt64(value) * UInt64(delta)) % 2147483647)
            if value % multi == 0 { break }
        }
        return value
    }
}

@main final class Today: Day {
    init() { super.init(day: 15, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        
        var generatorA = Generator(value: 116, delta: 16807, multi: 1)
        var generatorB = Generator(value: 299, delta: 48271, multi: 1)
        var count = 0
        for _ in 0..<40_000_000 {
            if (generatorA.next() & 0xFFFF == generatorB.next() & 0xFFFF) { count += 1 }
        }
        print("There are \(count) matches")
        
        generatorA = Generator(value: 116, delta: 16807, multi: 4)
        generatorB = Generator(value: 299, delta: 48271, multi: 8)
        count = 0
        for _ in 0..<5_000_000 {
            if (generatorA.next() & 0xFFFF == generatorB.next() & 0xFFFF) { count += 1 }
        }
        print("There are \(count) matches with new generator logic")
    }
    
    static func main() { Today().run() }
}
