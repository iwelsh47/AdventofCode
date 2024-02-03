//
//  Day19.swift
//  Day19_2016
//
//  Created by Ivan Welsh on 27/01/24.
//

import Foundation

class Elf {
    var presents: Int
    let index: Int
    // Doubly linked list
    var left: Elf?
    var right: Elf?
    
    init(index: Int) {
        self.presents = 1
        self.index = index
        self.left = nil
        self.right = nil
    }
    
    func remove() {
        if let left { left.right = right }
        if let right { right.left = left }
    }
    
    func skipAhead(left amount: Int) -> Elf {
        var skippedElf = self
        for _ in 0..<amount {
            skippedElf = skippedElf.left!
        }
        return skippedElf
    }
    
    func skipAhead(right amount: Int) -> Elf {
        var skippedElf = self
        for _ in 0..<amount {
            skippedElf = skippedElf.right!
        }
        return skippedElf
    }
}

func constructElfCircle(numElves: Int) -> (first: Elf, middle: Elf) {
    let elves = (1...numElves).map({ Elf(index: $0) })
    for (index, elf) in elves.enumerated() {
        let leftIndex = (index + 1) % numElves
        let rightIndex = index == 0 ? numElves - 1 : index - 1
        elf.left = elves[leftIndex]
        elf.right = elves[rightIndex]
    }
    return (elves.first!, elves[numElves / 2])
}

func stealFrom(numElves: Int) -> Int {
    var (elf, _) = constructElfCircle(numElves: numElves)
    var elfCount = numElves
    while elfCount != 1 {
        let stealFrom = elf.skipAhead(left: 1)
        elf.presents += stealFrom.presents
        stealFrom.remove()
        elf = elf.skipAhead(left: 1)
        elfCount -= 1
    }
    return elf.index
}

func stealFromAcross(numElves: Int) -> Int {
    var (elf, stealFrom) = constructElfCircle(numElves: numElves)
    var elfCount = numElves
    while elfCount != 1 {
        elf.presents += stealFrom.presents
        stealFrom.remove()
        stealFrom = stealFrom.skipAhead(left: elfCount.isMultiple(of: 2) ? 1 : 2)
        elf = elf.skipAhead(left: 1)
        elfCount -= 1
    }
    return elf.index
}

@main final class Today: Day {
    init() { super.init(day: 19, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let numElves = 3001330
        print("Steal from neighbour winning elf is \(stealFrom(numElves: numElves))")
        print("Steal from across winning new method is \(stealFromAcross(numElves: numElves))")
    }
    
    static func main() { Today().run() }
}
