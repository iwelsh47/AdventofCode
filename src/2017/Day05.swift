//
//  Day05.swift
//  Day05_2017
//
//  Created by Ivan Welsh on 4/02/24.
//

import Foundation

func stepsToEscape(from: [Int]) -> Int {
    var jumps = from
    var idx = 0
    var steps = 0
    while idx >= 0 && idx < jumps.count {
        let delta = jumps[idx]
        jumps[idx] += 1
        idx += delta
        steps += 1
    }
    return steps
}

func strangeStepsToEscape(from: [Int]) -> Int {
    var jumps = from
    var idx = 0
    var steps = 0
    while idx >= 0 && idx < jumps.count {
        let delta = jumps[idx]
        if delta >= 3 { jumps[idx] -= 1 }
        else { jumps[idx] += 1 }
        idx += delta
        steps += 1
    }
    return steps
}

@main final class Today: Day {
    init() { super.init(day: 5, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let jumpInstructions = data.components(separatedBy: .newlines).map{ Int($0)! }
        print("Steps to escape is \(stepsToEscape(from: jumpInstructions))")
        print("Strange steps to escape is \(strangeStepsToEscape(from: jumpInstructions))")
    }
    
    static func main() { Today().run() }
}
