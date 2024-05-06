//
//  Day06.swift
//  Day06_2017
//
//  Created by Ivan Welsh on 5/02/24.
//

import Foundation

func nextIteration(of dat: [Int]) -> [Int] {
    var nextVal = dat
    var idx = nextVal.firstIndex(of: nextVal.max()!)!
    var toShift = nextVal[idx]
    nextVal[idx] = 0
    while toShift > 0 {
        idx = (idx + 1) % nextVal.count
        nextVal[idx] += 1
        toShift -= 1
    }
    return nextVal
}

func iterationToRepeat(of dat: [Int]) -> (count: Int, repeat: [Int]) {
    var seenArrangments = Set([dat])
    var nextItr = nextIteration(of: dat)
    while !seenArrangments.contains(nextItr) {
        seenArrangments.insert(nextItr)
        nextItr = nextIteration(of: nextItr)
    }
    return (seenArrangments.count, nextItr)
}

@main final class Today: Day {
    init() { super.init(day: 6, year: 2017) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let initialMem = [4, 1, 15, 12, 0, 9, 9, 5, 5, 8, 7, 3, 14, 5, 12, 3]
        let testMem = [0, 2, 7, 0]
        let (count, repeatState) = iterationToRepeat(of: initialMem)
        print("Number of iterations to reach infinte loop: \(count)")
        print("Loop length = \(iterationToRepeat(of: repeatState).count)")
    }
    
    static func main() { Today().run() }
}
