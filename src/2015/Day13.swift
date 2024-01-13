//
//  Day13.swift
//  Day13_2015
//
//  Created by Ivan Welsh on 14/01/24.
//

import Foundation
import Algorithms

struct HappinessUnits {
    let happinessEffects: [String: [String: Int]]
    
    init(from interactions: String) {
        var happinessEffects = [String: [String: Int]]()
        
        for interaction in interactions.components(separatedBy: "\n") {
            let bits = interaction.components(separatedBy: " ")
            let personA = bits[0]
            let personB = String(bits[10][..<bits[10].index(before: bits[10].endIndex)])
            let happiness = Int(bits[3])! * (bits[2] == "lose" ? -1 : 1)
            
            if happinessEffects[personA] != nil {
                happinessEffects[personA]![personB] = happiness
            } else {
                happinessEffects[personA] = [personB : happiness]
            }
        }
        
        self.happinessEffects = happinessEffects
    }
    
    func totalHappiness(of seating: [String]) -> Int {
        var totalHappiness = 0
        for selfIndex in 0..<seating.count {
            let leftIndex = (selfIndex == 0) ? seating.count - 1 : selfIndex - 1
            let rightIndex = (selfIndex == seating.count - 1) ? 0 : selfIndex + 1
            totalHappiness += happinessEffects[seating[selfIndex]]?[seating[leftIndex]] ?? 0
            totalHappiness += happinessEffects[seating[selfIndex]]?[seating[rightIndex]] ?? 0
        }
        return totalHappiness
    }
    
    func bestSeatingArrangment(includingSelf: Bool = false) -> (arrangment: [String], happiness: Int) {
        var people = happinessEffects.keys.map({ $0 })
        if includingSelf { people.append("Myself") }
        var bestScore = Int.min
        var bestArrangment = people
        for arrangment in people.permutations() {
            let score = totalHappiness(of: arrangment)
            if score > bestScore {
                bestScore = score
                bestArrangment = arrangment
            }
        }
        return (bestArrangment, bestScore)
    }
}

@main final class Today: Day {
    init() { super.init(day: 13, year: 2015) }
    
    override func run() {
        print("Running \(year), day \(day)")
        let happinessPlanner = HappinessUnits(from: data)
        print("Best seating is \(happinessPlanner.bestSeatingArrangment())")
        print("And with me also sitting it is \(happinessPlanner.bestSeatingArrangment(includingSelf: true))")
    }
    
    static func main() { Today().run() }
}
