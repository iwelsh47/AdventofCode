//
//  Day24.swift
//  Day24_2015
//
//  Created by Ivan Welsh on 16/01/24.
//

import Foundation
import Algorithms

struct Group: Comparable {
    static func < (lhs: Group, rhs: Group) -> Bool {
        if lhs.data.count == rhs.data.count {
            return lhs.qe < rhs.qe
        } else {
            return lhs.data.count < rhs.data.count
        }
    }
    var qe: Int { get { data.reduce(1, { $0 * $1 }) } }
    var count: Int { get { data.count } }
    var isEmpty: Bool { get { data.isEmpty } }
    let data: Set<Int>
    
}

@main final class Today: Day {
    init() { super.init(day: 24, year: 2015) }
    let weights = Set([1, 2, 3, 5, 7, 13, 17, 19, 23, 29, 31, 37, 41, 43, 53, 59, 61, 67, 71, 73, 79,
                       83, 89, 97, 101, 103, 107, 109, 113])
    
    func bestPackages(numCompartments: Int, weights: Set<Int>, doBestCombo: Bool = true) -> [Group] {
        if numCompartments == 1 { return [Group(data: weights)] }
        
        let weightPer = weights.reduce(0, { $0 + $1 }).quotientAndRemainder(dividingBy: numCompartments).quotient
        
        var minElements = Set<Int>([weights.max()!])
        while minElements.sum() < weightPer {
            minElements.insert(weights.subtracting(minElements).max()!)
        }
        let minSize = minElements.count
        
        var maxElements = Set<Int>([weights.min()!])
        while maxElements.sum() < weightPer {
            maxElements.insert(weights.subtracting(maxElements).min()!)
        }
        let maxSize = maxElements.count
        
        let lazyCombos = weights.lazy.combinations(ofCount: minSize...maxSize)
        var bestCombo = Group(data: maxElements)
        var bestOrdered: [Group] = []
        var skippedCount = (badSum: 0, worseScore: 0)
        for combo in lazyCombos {
            if combo.sum() != weightPer { skippedCount.badSum += 1; continue }
            if combo.count > bestCombo.count { break }
            let comboGroup = Group(data: Set(combo))
            if doBestCombo && comboGroup > bestCombo { skippedCount.worseScore += 1; continue }
            let bestSubcombo = bestPackages(numCompartments: numCompartments - 1,
                                            weights: weights.subtracting(combo),
                                            doBestCombo: false)
            if !doBestCombo { return [comboGroup] + bestSubcombo }
            if comboGroup < bestCombo {
                bestCombo = comboGroup
                bestOrdered = [comboGroup] + bestSubcombo
            }
        }
        print("Level \(numCompartments) skips \(skippedCount).")
        return bestOrdered
    }
    
    override func run() {
        print("Running \(year), day \(day)")
        
        let bestGroupOf3 = bestPackages(numCompartments: 3, weights: weights)
        print("QE of best group of 3 is \(bestGroupOf3.first?.qe ?? -1)")
        let bestGroupOf4 = bestPackages(numCompartments: 4, weights: weights)
        print("QE of best group of 4 is \(bestGroupOf4.first?.qe ?? -1)")
    }
    
    static func main() { Today().run() }
}


