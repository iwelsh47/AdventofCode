//
//  Day15.swift
//  Day15_2016
//
//  Created by Ivan Welsh on 27/01/24.
//

import Foundation

struct Disc {
    let numPositions: Int
    let initialPosition: Int
    let stackIndex: Int
    
    func canPass(at time: Int) -> Bool {
        return ((initialPosition + time + stackIndex + 1) % numPositions) == 0
    }
    
    func timeToFirstPass() -> Int {
        var time = 0
        while !canPass(at: time) { time += 1}
        return time
    }
}


func findFirstTimeToPressButton(discs: [Disc]) -> Int {
    var time = discs.map{ $0.timeToFirstPass() }.max()!
    let delta = discs.map{ $0.numPositions }.max()!
    while !discs.allSatisfy({ $0.canPass(at: time) }) { time += delta }
    return time
}


@main final class Today: Day {
    init() { super.init(day: 15, year: 2016) }
    
    override func run() {
        print("Running \(year), day \(day)")
        // Find the first time to press the button
        var puzzleInput = [
            Disc(numPositions: 17, initialPosition: 15, stackIndex: 0),
            Disc(numPositions: 3, initialPosition: 2, stackIndex: 1),
            Disc(numPositions: 19, initialPosition: 4, stackIndex: 2),
            Disc(numPositions: 13, initialPosition: 2, stackIndex: 3),
            Disc(numPositions: 7, initialPosition: 2, stackIndex: 4),
            Disc(numPositions: 5, initialPosition: 0, stackIndex: 5)
        ]
        
        print("The first time to press the button is \(findFirstTimeToPressButton(discs: puzzleInput))")
        puzzleInput.append(Disc(numPositions: 11, initialPosition: 0, stackIndex: 6))
        print("With additional disc, the time to press is \(findFirstTimeToPressButton(discs: puzzleInput))")
    }
    
    static func main() { Today().run() }
}


